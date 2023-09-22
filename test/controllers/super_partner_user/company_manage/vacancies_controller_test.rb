require "test_helper"

class SuperPartnerUser::CompanyManage::VacanciesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get super_partner_user_company_manage_vacancies_index_url
    assert_response :success
  end
end
