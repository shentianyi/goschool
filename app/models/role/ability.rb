class Ability
  include CanCan::Ability

  def initialize(user)
    if Role.admin?(user.role_ids)
      can :manage,:all
    elsif Role.manager?(user.role_ids)
      can :manage,:all
      can :read,:all
    elsif Role.sale?(user.role_ids)
      can :manage,[Cousultation,Student,LogininfoSession,Attachment,FileData]
      can :manage,[Logininfo],:id=>user.id
      can :read,:all
    elsif Role.student?(user.role_ids)
      #can :manage,:all
      can :manage,[LogininfoSession,Attachment,FileData,Post,Comment]
      can :manage,[Student],:student_id=>user.student.id
      can :manage,[Logininfo],:id=>user.id
      can :manage,[StudentHomework,Homework]
      can :read,:all
    elsif Role.teacher?(user.role_ids)
      can :manage,[LogininfoSession,Homework,StudentHomework,Attachment,FileData]
      can :manage,:all
      can :read,:all
    end
  end
end
