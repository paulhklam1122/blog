require 'rails_helper'

RSpec.describe Post, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe "validations" do
    it "requires a title" do
      p = Post.new
      p.valid?
      expect(p.errors).to have_key(:title)
    end
    it "requires a minimum 7 characters for the title" do
      p = Post.new title: "this"
      p.valid?
      expect(p.errors).to have_key(:title)
    end
    it "requires the presence of a body" do
      p = Post.new
      p.valid?
      expect(p.errors).to have_key(:body)
    end
  end

  describe ".body_snippet" do
    it "returns expected result of 100 characters followed by..." do
      p = Post.new body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      expect(p.body_snippet.length).to eq(103)
    end
  end
end
