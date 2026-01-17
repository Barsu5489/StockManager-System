require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new (login page)" do
    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    post session_url, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_url
  end

  test "should not create session with invalid password" do
    post session_url, params: { email_address: @user.email_address, password: "wrongpassword" }
    assert_redirected_to new_session_url
    follow_redirect!
    assert_match "Try another email address or password", response.body
  end

  test "should not create session with invalid email" do
    post session_url, params: { email_address: "invalid@example.com", password: "password" }
    assert_redirected_to new_session_url
  end

  test "should destroy session (logout)" do
    # First sign in
    post session_url, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_url

    # Then sign out
    delete session_url
    assert_redirected_to new_session_url
  end

  test "should redirect to requested page after login" do
    # Try to access products without being logged in
    get products_url
    assert_redirected_to new_session_url

    # Log in
    post session_url, params: { email_address: @user.email_address, password: "password" }

    # Should redirect to originally requested page
    assert_redirected_to products_url
  end
end
