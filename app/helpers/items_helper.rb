module ItemsHelper
  def user_is_authorized_for_item?(item)
    current_user && current_user == item.user
  end
end
