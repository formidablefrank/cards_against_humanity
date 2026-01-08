# frozen_string_literal: true

require 'rake'

class DeleteOldGamesWorker
  include Sidekiq::Worker

  def perform
    Rails.application.load_tasks
    task_name = 'db:delete_old_games'
    Rake::Task[task_name].invoke
  end
end
