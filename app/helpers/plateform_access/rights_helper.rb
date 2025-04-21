module PlateformAccess
  module RightsHelper
    def current_user_rights_animator_and_up?
      current_user&.super_admin? || current_user&.administrator? || current_user&.organiser? || current_user&.animator?
    end

    def current_user_is_admin?
      current_user&.super_admin? || current_user&.administrator?
    end

    def current_user_can_create_general_public_sessions?
      current_user&.super_admin? || current_user&.administrator? || current_user&.organiser?
    end
  end
end
