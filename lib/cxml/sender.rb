module CXML
  class Sender
    attr_accessor :credential
    attr_accessor :user_agent

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @credential = CXML::Credential.new(data['Credential'])
        @user_agent = data['UserAgent']
      end
    end

    def render(node)
      node.Sender do |n|
        @credential.render(n)
        n.UserAgent(@user_agent)
      end
      node
    end
  end
end