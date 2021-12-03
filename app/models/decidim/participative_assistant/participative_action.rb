module Decidim
  module ParticipativeAssistant
    class ParticipativeAction < ApplicationRecord
      self.table_name = 'decidim_participative_actions'
      belongs_to :organization

      validates :organization, presence: true

      scope :recommendations, -> { ParticipativeAction.uncompleted.order(:points).limit(3) }
      scope :uncompleted, -> { where(completed: false) }
      scope :completed, -> { where(completed: true) }
      scope :edition, -> { where(category: "Edition") }
      scope :edition, -> { where(category: "Edition") }
      scope :edition, -> { where(category: "Edition") }
      scope :edition, -> { where(category: "Edition") }

      def self.last_done_recommendations
        participative_action = organization.assistant['last']
        return unless participative_action >= 0

        ParticipativeAction.find(participative_action)
      end

      def self.palierScores
        paliers = []
        (1..5).each do |i|
          if i == 1
            paliers.append(ParticipativeAction.where(points: i).size)
          else
            paliers.append(ParticipativeAction.where(points: i).size * i + paliers[i - 2])
          end
        end
        return paliers
      end
    end
  end
end
