module RolesHelper
  def readable_role_type(type)
    case type
      when Role::Type::SUPER_ADMIN
        "Super Admin"
      when Role::Type::CLIENT_ADMIN
        "Client Admin"
      when Role::Type::PROJECT_OWNER
        "Project Owner"
      when Role::Type::READER
        "Reader"
    end
  end
  
  def roles_user_can_assign(user)
    user.role_types_can_assign.map {|r| [readable_role_type(r), r]}
  end
end