class UserAnswer < ActiveRecord::Base
  belongs_to :user

    validates :question1, presence: true
    validates :question2, presence: true
    validates :question3, presence: true
end
