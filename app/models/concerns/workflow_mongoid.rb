module WorkflowMongoid
  extend ActiveSupport::Concern

  included do
    before_validation :write_initial_state

    field :workflow_state

    def next_state!
      self.send("#{current_state.events.keys.first.to_s}!")
      save!
    end

    def load_workflow_state
      self[:workflow_state]
    end

    def persist_workflow_state(new_value)
      self[:workflow_state] = new_value
      save!
    end

    def write_initial_state
      send("#{self.class.workflow_column}=", current_state.to_s) if load_workflow_state.blank?
    end
  end
end
