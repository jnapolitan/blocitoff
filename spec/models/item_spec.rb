require 'rails_helper'

RSpec.describe Item, type: :model do

  let(:user) { create(:user) }
  let(:item) { create(:item, user: user) }

  it { is_expected.to belong_to(:user) }

  describe "attributes" do
    it "responds to name" do
      expect(item).to respond_to(:name)
    end
  end
end
