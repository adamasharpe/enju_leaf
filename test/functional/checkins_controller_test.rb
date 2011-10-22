require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
    fixtures :checkins, :checkouts, :users, :patrons, :roles, :user_groups, :reserves, :baskets, :library_groups, :checkout_types, :patron_types,
    :user_group_has_checkout_types, :carrier_type_has_checkout_types,
    :manifestations, :carrier_types,
    :items, :circulation_statuses,
    :shelves, :request_status_types,
    :content_types, :languages, :message_templates

  def test_everyone_should_not_create_checkin_without_item_id
    sign_in users(:admin)
    assert_no_difference('Checkin.count') do
      post :create, :checkin => {:item_identifier => nil}, :basket_id => 9
    end
    
    assert_response :redirect
    assert_redirected_to user_basket_checkins_url(assigns(:basket).user.username, assigns(:basket))
    #assert_response :success
  end

  def test_system_should_show_notice_when_other_library_item
    sign_in users(:librarian2)
    assert_difference('Checkin.count') do
      post :create, :checkin => {:item_identifier => '00009'}, :basket_id => 9
    end
    assert flash[:message].to_s.index(I18n.t('checkin.other_library_item'))
    
    assert_redirected_to user_basket_checkins_url(assigns(:basket).user.username, assigns(:basket))
  end

  def test_everyone_should_not_show_missing_checkin
    sign_in users(:admin)
    get :show, :id => 100
    assert_response :missing
  end

  def test_everyone_should_not_get_missing_edit
    sign_in users(:admin)
    get :edit, :id => 100
    assert_response :missing
  end
  
  def test_everyone_should_not_update_missing_checkin
    sign_in users(:admin)
    put :update, :id => 100, :checkin => { }
    assert_response :missing
  end

  def test_everyone_should_not_destroy_missing_checkin
    sign_in users(:admin)
    assert_no_difference('Checkin.count') do
      delete :destroy, :id => 100
    end
    
    assert_response :missing
  end
end
