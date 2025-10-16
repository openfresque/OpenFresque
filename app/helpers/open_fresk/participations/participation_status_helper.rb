module OpenFresk
  module Participations
    module ParticipationStatusHelper
      def participant_status(participation)
        if participation.nil?
          return content_tag(:span, "- #{t('invitations.present', count: 1)}",
                             class: 'small text-success')
        end
        if participation.pending?
          return content_tag(:span, "- #{t('invitations.pending', count: 1)}",
                             class: 'small text-warning')
        end
        if participation.confirmed?
          return content_tag(:span, "- #{t('invitations.confirmed', count: 1)}",
                             class: 'small text-success')
        end
        if participation.declined?
          return content_tag(:span, "- #{t('invitations.declined', count: 1)}",
                             class: 'small text-danger')
        end
        return unless participation.present?

        content_tag(:span, "- #{t('invitations.present', count: 1)}",
                    class: 'small text-success')
      end

      def facilitator_status(participation)
        case participation.facilitator_role
        when Participation::Observer
          content_tag(:div, t('invitations.observe'))
        when Participation::Coanimator
          content_tag(:div, t('invitations.coanime'))
        when Participation::Facilitator
          content_tag(:div, t('invitations.anime'))
        when Participation::Coach
          content_tag(:div, t('invitations.coach'))
        end
      end
    end
  end
end
