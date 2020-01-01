class AuthenticableTest < ActionDispatch::IntegrationTest
    setup do
        @user = users(:one)
        @authentication = MockController.new
    end

    class MockController
        include Authenticable
        attr_accessor :request

        def initialize
            mock_request = Struct.new(:headers)
            self.request = mock_request.new({})
        end
    end

    test 'should get users from Authorization token' do
        @authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: @user.id)
        assert_equal @user.id, @authentication.current_user.id
    end

    test 'should not get users from empty Authorization token' do
        @authentication.request.headers['Authorization'] = nil
        assert_nil @authentication.current_user
    end
end