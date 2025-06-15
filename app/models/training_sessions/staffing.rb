module TrainingSessions
  module Staffing
    def capacity_table
      (capacity / participants_per_table.to_f).ceil
    end

    def participants_per_table
      if atelier? && onsite?
        OpenFresk::Constants::ParticipantsPerTable::ATELIER_ONSITE
      elsif atelier? && online?
        OpenFresk::Constants::ParticipantsPerTable::ATELIER_ONLINE
      elsif formation? && onsite?
        OpenFresk::Constants::ParticipantsPerTable::FORMATION_ONSITE
      elsif formation? && online?
        OpenFresk::Constants::ParticipantsPerTable::FORMATION_ONLINE
      end
    end

    def animation_open?
      return if observer_count.nil? || coanimator_count.nil? || animator_count.nil? || coach_count.nil?

      observer_count > 0 || coanimator_count > 0 || animator_count > 0 || coach_count > 0
    end

    def animation_full?
      return if observer_count.nil? || coanimator_count.nil? || animator_count.nil? || coach_count.nil?

      !observer_role_open? && !coanimator_role_open? && !animator_role_open? && !coach_role_open?
    end

    def observer_role_open?
      return if observer_count.nil?

      if participations.find_by(animator_id: created_by_user_id).nil?
        observer_count > observer_enumerate
      elsif participations.find_by(animator_id: created_by_user_id).animator_role == Participation::Observer
        observer_count + 1 > observer_enumerate
      else
        observer_count > observer_enumerate
      end
    end

    def coanimator_role_open?
      return if coanimator_count.nil?

      if participations.find_by(animator_id: created_by_user_id).nil?
        coanimator_count > coanimator_enumerate
      elsif participations.find_by(animator_id: created_by_user_id).animator_role == Participation::Coanimator
        coanimator_count + 1 > coanimator_enumerate
      else
        coanimator_count > coanimator_enumerate
      end
    end

    def animator_role_open?
      return if animator_count.nil?

      if participations.find_by(animator_id: created_by_user_id).nil?
        animator_count > leading_animator_count
      elsif participations.find_by(animator_id: created_by_user_id).animator_role == Participation::Animator
        animator_count + 1 > leading_animator_count
      else
        animator_count > leading_animator_count
      end
    end

    def coach_role_open?
      return if coach_count.nil?

      if participations.find_by(animator_id: created_by_user_id).nil?
        coach_count > coach_enumerate
      elsif participations.find_by(animator_id: created_by_user_id).animator_role == Participation::Coach
        coach_count + 1 > coach_enumerate
      else
        coach_count > coach_enumerate
      end
    end

    def participant_capacity_full?
      confirmed_present_count >= capacity
    end

    def table_quantity_sum
      participations.where("animator_id = user_id").sum(:table_quantity)
    end

    def total_animator_table_quantity_count
      table_quantity_sum + (coanimator_count.to_f / 2).floor
    end

    def session_open?
      animator_role_open? || observer_role_open? || coanimator_role_open?
    end

    def lack_of_animator?
      total_animator_table_quantity_count < confirmed_present_tables_count
    end

    def too_many_animator?
      (leading_animator_count + coanimator_count.to_f) / 2 > confirmed_present_tables_count
    end

    def seats_free
      capacity - confirmed_present_count
    end

    def confirmed_present_tables_count
      (confirmed_present_count / participants_per_table.to_f).ceil
    end

    def has_presents_participants?
      participations.where(animator_role: nil, status: Participation::Present).count > 0
    end
  end
end
