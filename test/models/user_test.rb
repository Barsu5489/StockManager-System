require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with email and password" do
    user = User.new(email_address: "test@example.com", password: "password123")
    assert user.valid?
  end

  test "should normalize email address to lowercase" do
    user = User.new(email_address: "TEST@EXAMPLE.COM", password: "password123")
    user.save
    assert_equal "test@example.com", user.email_address
  end

  test "should strip whitespace from email" do
    user = User.new(email_address: "  test@example.com  ", password: "password123")
    user.save
    assert_equal "test@example.com", user.email_address
  end

  test "should have many sessions" do
    user = users(:one)
    assert_respond_to user, :sessions
  end

  test "should destroy sessions when user is destroyed" do
    user = users(:one)
    # Create a session for the user
    user.sessions.create!(user_agent: "Test", ip_address: "127.0.0.1")
    session_count = user.sessions.count

    assert session_count > 0
    assert_difference("Session.count", -session_count) do
      user.destroy
    end
  end

  test "should authenticate with correct password" do
    user = users(:one)
    assert User.authenticate_by(email_address: user.email_address, password: "password")
  end

  test "should not authenticate with wrong password" do
    user = users(:one)
    assert_nil User.authenticate_by(email_address: user.email_address, password: "wrongpassword")
  end
end
