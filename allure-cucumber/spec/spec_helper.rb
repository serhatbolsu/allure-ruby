# frozen_string_literal: true

require "rspec"
require "simplecov"
require "cucumber"
require "allure-ruby-commons"
require "allure-cucumber"
require "digest"

SimpleCov.command_name("allure-cucumber")

RSpec.shared_context("allure mock") do
  let(:lifecycle) { spy("lifecycle") }

  before do
    allow(Allure).to receive(:lifecycle).and_return(lifecycle)
  end
end

RSpec.shared_context("cucumber runner") do
  def run_cucumber_cli(feature, *additional_args)
    configuration = Cucumber::Cli::Configuration.new.tap do |config|
      args = [feature, "--format", "AllureCucumber::CucumberFormatter"]
      args.push(*additional_args)
      config.parse!(args)
    end
    runtime = Cucumber::Runtime.new.tap do |run|
      run.configure(configuration)
    end

    runtime.run!
  end
end

Allure.configure do |config|
  config.clean_results_directory = true
end
