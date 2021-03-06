require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      :item_name => "MyString",
      :rate => 1
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input#item_item_name[name=?]", "item[item_name]"

      assert_select "input#item_rate[name=?]", "item[rate]"
    end
  end
end
