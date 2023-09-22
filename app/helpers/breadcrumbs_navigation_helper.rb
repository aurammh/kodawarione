module BreadcrumbsNavigationHelper
    def ensure_breadcrumbs_navigation
      if current_page?(new_user_session_path) || current_page?(new_user_registration_path) || current_page?(new_user_password_path)
        @navigation ||= [{ title: "ホーム".html_safe, url: root_path }]
      else
        @navigation ||= [{ title: "ホーム".html_safe, url: root_path }]
      end
    end
  
    def breadcrumbs_navigation_add(title, url)
      ensure_breadcrumbs_navigation << { title: title, url: url }
    end
  
    def render_student_breadcrumbs_navigation(name)
      render partial: 'common/student_breadcrumbs_navigation', locals: { nav: ensure_breadcrumbs_navigation, current_page_name: name }
    end

    def render_company_breadcrumbs_navigation(name)
      render partial: 'layouts/header/company_header', locals: { nav: ensure_breadcrumbs_navigation, current_page_name: name }
    end

    def render_partner_breadcrumbs_navigation(name)
      render partial: 'layouts/header/partner_header', locals: { nav: ensure_breadcrumbs_navigation, current_page_name: name }
    end
end
  