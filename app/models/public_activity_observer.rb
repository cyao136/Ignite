class PublicActivityObserver < ActiveRecord::Observer
  observe PublicActivity::Activity
  def after_save(activity)
    if activity.owner_type == "User"
      User.find(activity.owner_id).after_activity_save(activity)
    end
  end
end
