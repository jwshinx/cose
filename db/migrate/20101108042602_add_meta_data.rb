class AddMetaData < ActiveRecord::Migration
  def self.up
    Status.delete_all
    Status.create(:name => 'done', :description => 'completed, yay')
    Status.create(:name => 'pending', :description => 'not done yet')

    Category.delete_all  
    Category.create(:name => 'home', :description => 'house bills, chores')
    Category.create(:name => 'job', :description => 'job search')
    Category.create(:name => 'education', :description => 'theory')
    Category.create(:name => 'diva', :description => 'diva stuff')
  end

  def self.down
    Status.delete_all
    Category.delete_all  
  end
end
