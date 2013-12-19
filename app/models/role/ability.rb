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
      can :read,[Homework]
      can :manage,[StudentHomework]
      can :manage,[Post,Comment]
    elsif Role.teacher?(user.role_ids)
      can :manage,[LogininfoSession,Homework,StudentHomework]
    end
  end
end
