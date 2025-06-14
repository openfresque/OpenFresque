module OpenFresk
  module TrainingSessionHelper
    def show_session_link(session, filter = nil)
      TrainingSessions::Redirection.new(
        training_session: session,
        current_user:,
        filter:
      ).call
    end

    def show_session_url(session)
      if SessionParticipationPolicy.new(current_user, session).show?
        session_participation_url(session.uuid, host: ENV["HOST"], anchor: "animent")
      else
        session_invitation_url(session.uuid, host: ENV["HOST"], anchor: "animent")
      end
    end

    def show_public_session_url(session, current_user)
      #language = Languages::SetLanguage.new(params, current_user).call
      show_public_training_session_url(
        session.id,
        host: ENV["HOST"],
      )
    end

    def edit_link_session_url(session)
      edit_training_session_path(session.id)
    end

    def session_location(session)
      if session.onsite?
        t("training_sessions.onsite")
      else
        t("training_sessions.online")
      end
    end

    def session_category(session)
      if session.atelier?
        t("atelier", count: 1)
      else
        t("formation", count: 1)
      end
    end

    # Progress bar : % of seats booked
    def seats_booked_progress_bar(session)
      progress = session.confirmed_present_count / session.capacity.to_f * 100
      content_tag(:div,
                  content_tag(:div, "", class: "progress-bar bg-secondary w-#{progress}",
                              role: "progressbar", style: "width: #{progress}%",
                              aria_valuenow: "#{session.confirmed_present_count}",
                              aria_valuemin: "0", aria_valuemax: "#{session.capacity}"),
                  class: "progress w-100", style: "height: 8px;")
    end

    def seats_text(session)
      content_tag(:span, class: "mx-2") { "#{session.confirmed_present_count} participent / #{session.capacity}" }
    end

    # Progress bar : % of tables filled
    def tables_progress_bar(session)
      progress = if session.capacity_table.zero?
        0
      else
        (session.table_quantity_sum.to_f * 100).ceil / session.capacity_table
      end
      content_tag(:div,
                  content_tag(:div, "", class: "progress-bar bg-secondary w-#{progress}",
                              role: "progressbar", style: "width: #{progress}%",
                              aria_valuenow: "#{session.confirmed_present_count}",
                              aria_valuemin: "0", aria_valuemax: "#{session.capacity_table}"),
                  class: "progress w-100", style: "height: 8px;")
    end

    def table_text(session)
      tables = table_quantity_sum(session)
      content_tag(:span, class: "mx-2") { "#{tables} tables / #{session.capacity_table}" }
    end

    def organize_badge(session, current_user)
      return unless current_user

      return unless session.created_by_user_id == current_user&.id

      content_tag(:span, class: "px-2 py-1 rounded-pill bg-grey-500 text-dark small") do
        t("training_sessions.i_organize")
      end
    end

    def anim_badge(session, current_user)
      return unless current_user
      return if session.participations.where(animator_id: current_user.id, animator_role: Participation::Coach).exists?

      return unless session.participations.where(animator_id: current_user.id).exists?

      text = if session.observer?(current_user)
        "i_observe"
      else
        "i_animate"
      end
      content_tag(:span, class: "px-2 py-1 rounded-pill bg-grey-500 text-dark small") { t("training_sessions.#{text}") }
    end

    def coach_badge(session, current_user)
      return unless session.participations.where(animator_id: current_user.id,
                                                 animator_role: Participation::Coach).exists? && current_user

      content_tag(:span, class: "px-2 py-1 rounded-pill bg-grey-500 text-dark small") { t("training_sessions.i_coach") }
    end

    def public_session_link(session, current_user = nil)
      language = Languages::SetLanguage.new(params, current_user).call
      user_token = current_user&.token
      if session.participant_capacity_full?
        ""
      else
        show_public_training_session_path(session, language: language, user_token: user_token)
      end
    end

    def public_session_participation_link(participation)
      language = if participation.user&.last_sign_in_at.nil?
        params[:language].present? ? params[:language] : "en"
      else
        participation.user.native_language
      end
      if participation.confirmed?
        participation_url(
          participation.id,
          host: ENV["HOST"],
          token: participation.user.token,
          language: language
        )
      elsif participation.training_session.participant_capacity_full?
        "#"
      else
        ticket_choice_training_session_public_participations_path(participation.training_session, user_token: participation.user&.token, language: language)
      end
    end

    def public_session_participation_style(participation)
      if participation.confirmed?
        "link-success"
      elsif participation.training_session.participant_capacity_full?
        "disabled"
      else
        "link-secondary"
      end
    end

    def confirmation_message(_session, participation_status)
      case participation_status
        when Participation::Pending
          message = t("training_sessions.take_part")
          style = "link-secondary"
        when Participation::Confirmed
          message = t("training_sessions.i_take_part")
          style = "link-success"
        when Participation::Declined
          message = t("participations.declined")
          style = "link-warning"
      end
      [message, style]
    end

    def training_session_audience_select(mission, audience, current_user)
      if mission.present?
        text_field = text_field_tag "training_session[audience]",
                                    t("training_sessions.audience.#{audience.downcase}"),
                                    class: "form-control",
                                    disabled: true,
                                    "data-audience-target": "audience"
        hidden_field = hidden_field_tag "training_session[audience]", audience
        text_field + hidden_field
      else
        select_tag "training_session[audience]",
                   options_for_select(training_session_audience_grouped_options(current_user),
                                      params[:action] == "new" ? TrainingSession::Personal : @training_session.audience),
                   id: "audience",
                   class: "form-control mb-2",
                   required: true,
                   prompt: t("please_select"),
                   "data-audience-target": "audience",
                   "data-action": "change->audience#click"
      end
    end

    def training_session_audience_grouped_options(current_user)
      general_public_disabled = !current_user.administrator? && !current_user.super_admin? && !current_user.organiser?
      inter_company_disabled = !current_user.administrator? && !current_user.super_admin?
      [
        [t("training_sessions.audience.personal"), TrainingSession::Personal],
        [t("training_sessions.audience.general_public"), TrainingSession::GeneralPublic, {
          disabled: general_public_disabled
        }],
        [t("training_sessions.audience.education"), TrainingSession::Education],
        [t("training_sessions.audience.public_sector"), TrainingSession::PublicSector],
        [t("training_sessions.audience.company"), TrainingSession::Company],
        [t("training_sessions.audience.association"), TrainingSession::Association],
        [t("training_sessions.audience.inter_company"), TrainingSession::InterCompany, {
          disabled: inter_company_disabled
        }]
      ]
    end

    def training_session_role_grouped_options
      [
        [t("coanimation.no_role"), "unregistered"],
        [t("coanimation.observe"), "#{Participation::Observer}"],
        [t("coanimation.coanimate"), "#{Participation::Coanimator}"],
        [t("coanimation.animate_alone"), "#{Participation::Animator}"],
        [t("coanimation.coach"), "#{Participation::Coach}"]
      ]
    end

    def role_grouped_options_preselect(training_session, current_user, params)
      participation = training_session.participations.find_by(user_id: current_user.id)
      if params[:action] == "new"
        "unregistered" unless current_user.animator?
        "#{Participation::Animator}" if current_user.animator?
      elsif !participation.nil?
        participation.animator_role
      else
        "unregistered"
      end
    end

    def training_session_mission(training_session)
      if training_session.mission.present?
        hidden_field_tag "training_session[mission_id]", training_session.mission.id
      else
        hidden_field_tag "training_session[mission_id]", params[:mission_id]
      end
    end

    def context_grouped_options
      [
        [t("training_sessions.context.internal"), "#{TrainingSession::Internal}"],
        [t("training_sessions.context.commercial"), "#{TrainingSession::Commercial}"]
      ]
    end

    def context_grouped_options_selected(training_session)
      unless training_session.context == TrainingSession::Internal || training_session.context == TrainingSession::Commercial
        return
      end

      training_session.context
    end

    def user_licence_link(code_language)
      if code_language == :fr
        "https://fresqueduclimat.org/licence-et-droits-dutilisation/"
      else
        "https://climatefresk.org/world/licence-fees/"
      end
    end

    def roles_open(training_session)
      if training_session.animator_role_open? && !training_session.coanimator_role_open? && !training_session.observer_role_open? && !training_session.coach_role_open?
        animator_text = "#{t('coanimation.animate')} "
      elsif training_session.animator_role_open? && (training_session.coanimator_role_open? || training_session.observer_role_open? || training_session.coach_role_open?)
        animator_text = "#{t('coanimation.animate')}; "
      end

      if training_session.coanimator_role_open? && !training_session.observer_role_open? && !training_session.coach_role_open?
        coanimator_text = "#{t('coanimation.coanimate')} "
      elsif training_session.coanimator_role_open? && (training_session.observer_role_open? || training_session.coach_role_open?)
        coanimator_text = "#{t('coanimation.coanimate')}; "
      end

      if training_session.observer_role_open? && !training_session.coach_role_open?
        observer_text = "#{t('coanimation.observe')} "
      elsif training_session.observer_role_open? && training_session.coach_role_open?
        observer_text = "#{t('coanimation.observe')}; "
      end

      coach_text = "#{t('coanimation.coach')} " if training_session.coach_role_open?

      if training_session.animation_full?
        t("coanimation.roles_closed")
      else
        "#{t('coanimation.roles_open')}: #{animator_text}#{coanimator_text}#{observer_text}#{coach_text}"
      end
    end

    def training_registration_workshop_url
      language = Languages::SetLanguage.new(params, current_user).call
      case language
        when "fr"
          Constants::Urls::TRAINING_REGISTRATION_WORKSHOP_FR_URL
        when "en"
          Constants::Urls::TRAINING_REGISTRATION_WORKSHOP_EN_URL
        when "es"
          Constants::Urls::TRAINING_REGISTRATION_WORKSHOP_ES_URL
        else
          Constants::Urls::TRAINING_REGISTRATION_WORKSHOP_EN_URL
      end
    end

    # def manage_invitation(session, participation)
    #   if participation.confirmed?
    #     link_to t('participations.decline?'),
    #             manage_training_session_path(session, participation: participation.id, confirmation_token: params[:confirmation_token], manage_token: params[:manage_token], status: "declined", language: participation.user.native_language),
    #             class: "dropdown-item link-dark text-decoration-none"
    #   elsif participation.declined? || participation.pending?
    #     link_to t('participations.confirm?'),
    #             manage_training_session_path(session, participation: participation.id, confirmation_token: params[:confirmation_token], manage_token: params[:manage_token], status: "confirm", language: participation.user.native_language),
    #             class: "dropdown-item link-dark text-decoration-none"
    #   end
    # end
  end

end