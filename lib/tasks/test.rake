namespace :test do
  desc 'Run rspec'
  task run: :environment do
    require 'tty'
    require 'tty-command'

    abort 'InfluxDB not running' unless influx_running?

    command = TTY::Command.new(printer: :quiet, color: true)
    p "Running rspec via 'rspec'"
    start = Time.now
    begin
      # command.run('rspec')
      command.run("bundle exec rake 'parallel:spec[3]'")
    rescue TTY::Command::ExitError
      p 'TEST FAILED SAFELY'
    end
    finish = Time.now

    p 'Sending metrics to InfluxDB'
    TestDurationMetric.write(user: 'iL53n', run_time_seconds: (finish - start).to_i)
  end

  def influx_running?
    influx_endpoint = 'http://localhost:8086'
    puts "Check InfluxDB on #{influx_endpoint}..."

    command = TTY::Command.new(printer: :null)
    command.run!("curl #{influx_endpoint}/ping").success?
  end
end
