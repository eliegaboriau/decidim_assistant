# frozen_string_literal: true

require "decidim/participative_assistant/test/factories"
FactoryBot.define do
  sequence(:points) { |n| n }

  factory :participative_action, class: "Decidim::ParticipativeAssistant::ParticipativeAction" do
    organization {create(:organization)}
    completed { false }
    points { generate(:points) }
    resource { "Decidim::Assembly" }
    action { "publish" }
    category { "Edition" }
    recommendation { "Publish an assembly" }

    trait :completed do
      completed { true }
    end
  end
end

FactoryBot.modify do
  factory :organization, class: "Decidim::Organization" do
    name { Faker::Company.unique.name }
    reference_prefix { Faker::Name.suffix }
    time_zone { "UTC" }
    twitter_handler { Faker::Hipster.word }
    facebook_handler { Faker::Hipster.word }
    instagram_handler { Faker::Hipster.word }
    youtube_handler { Faker::Hipster.word }
    github_handler { Faker::Hipster.word }
    sequence(:host) { |n| "#{n}.lvh.me" }
    description { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    favicon { Decidim::Dev.test_file("icon.png", "image/png") }
    default_locale { Decidim.default_locale }
    available_locales { Decidim.available_locales }
    users_registration_mode { :enabled }
    official_img_header { Decidim::Dev.test_file("avatar.jpg", "image/jpeg") }
    official_img_footer { Decidim::Dev.test_file("avatar.jpg", "image/jpeg") }
    official_url { Faker::Internet.url }
    highlighted_content_banner_enabled { false }
    enable_omnipresent_banner { false }
    badges_enabled { true }
    user_groups_enabled { true }
    send_welcome_notification { true }
    comments_max_length { 1000 }
    admin_terms_of_use_body { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    force_users_to_authenticate_before_access_organization { false }
    machine_translation_display_priority { "original" }
    external_domain_whitelist { ["example.org", "twitter.com", "facebook.com", "youtube.com", "github.com", "mytesturl.me"] }
    smtp_settings do
      {
        "from" => "test@example.org",
        "user_name" => "test",
        "encrypted_password" => Decidim::AttributeEncryptor.encrypt("demo"),
        "port" => "25",
        "address" => "smtp.example.org"
      }
    end
    file_upload_settings { Decidim::OrganizationSettings.default(:upload) }
    enable_participatory_space_filters { true }
    assistant do
      {
        "last" => create(:participative_action, organization: organization),
        "flash" => "",
        "score" => 0,
      }
    end
  end
  end

