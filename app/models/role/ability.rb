class Ability
  include CanCan::Ability

  def initialize(user)
    if Role.admin?(user.role_ids)
      can :manage,:all
    elsif Role.manager?(user.role_ids)
      can :manage,:all
      can :read,:all
    elsif Role.sale?(user.role_ids)
      can :manage,[Cousultation,Student,LogininfoSession]
      can :manage,[Logininfo],:id=>user.id
      can :read,:all
    elsif Role.student?(user.role_ids)
      can :manage,[LogininfoSession]
      can :manage,[Student],:student_id=>user.student.id
      can :manage,[Logininfo],:id=>user.id
    elsif Role.teacher?(user.role_ids)
      can :manage,[LogininfoSession]
    end
  end
end