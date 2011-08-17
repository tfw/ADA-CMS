require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Re-authentication", %q{
  In order to not have to log in separately for each application
  As a user
  I want the system to synchronise my authentication data.
} do


  shared_examples_for "ADA CMS" do
    paths = [ '/', '/historical/home', '/ada/browse',
              '/archives/social_science/browse', '/historical/hccda',
              '/staff/home', '/staff/resources', '/staff/hccda' ]

    paths.each do |target_path|
      scenario "She can visit #{target_path}." do
        set_authentication_state
        visit target_path

        path_should_be target_path
      end
    end
  end


  background do
    @admin = make_user :administrator
  end

  context "An admin is logged in." do
    background do
      sign_in @admin
    end

    context "The authentication state is still valid." do
      background do
        @with_re_authentication = false
      end
 
      it_should_behave_like 'ADA CMS'
   end

    context "The authentication state is outdated." do
      background do
        @with_re_authentication = true
      end

      it_should_behave_like 'ADA CMS'
    end
  end


  def path_should_be(path)
    URI.parse(current_url).path.should == path
  end

  def set_authentication_state
    invalidate_authentication_state if @with_re_authentication
  end

  def invalidate_authentication_state
    key = OpenidClient::Config.server_timestamp_key
    timestamp = Time.now.to_f.to_s
    set_cookie key, timestamp

    # Making sure the cookie got set correctly.
    get_cookie(key).should == timestamp
  end

  def set_cookie(key, value)
    # This is how one needs to set cookies in Rack::Test.
    jar.merge "#{key.to_s}=#{value};domain=#{domain};path=/"
  end

  def get_cookie(key)
    jar[key.to_s]
  end

  def jar
    driver = Capybara.current_session.driver

    if Capybara::VERSION.starts_with? '1.'
      driver.class.should == Capybara::RackTest::Driver
      @jar ||= driver.browser.rack_mock_session.cookie_jar
    else
      driver.class.should == Capybara::Driver::RackTest
      @jar ||= driver.current_session.instance_variable_get(:@rack_mock_session).
        cookie_jar
    end
  end
  
  def domain
    @domain ||= URI.parse(current_url).host
  end
end
