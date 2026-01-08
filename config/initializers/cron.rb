# frozen_string_literal: true

if defined?(Sidekiq) && Sidekiq.server?
  require 'erb'
  require 'yaml'
  require 'sidekiq/cron/job'

  schedule_file = Rails.root.join('config', 'sidekiq.yml')

  if File.exist?(schedule_file)
    yaml = ERB.new(File.read(schedule_file)).result
    config = YAML.safe_load(yaml, aliases: true, permitted_classes: [Symbol])
    schedule = config[:schedule]

    Sidekiq::Cron::Job.load_from_hash(schedule)
  end
end
