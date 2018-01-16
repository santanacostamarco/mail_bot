require 'test_helper'

class ConversationControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get conversation_new_url
    assert_response :success
  end

end
