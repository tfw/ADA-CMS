module HelperMethods
  include Warden::Test::Helpers
  
  def search_form(term, page)
    fill_in("search_term", :with => term)
    page.find('#search_button').click
  end

  def search(term, view = "title", archive = Archive.ada)
    visit("/search?term=#{term}&view=#{view}&archive_id=#{archive.id}")
  end
  
  def visit_archive(slug)
    archive = Archive.find_by_slug(slug)
    visit staff_archive_path(archive)
  end

  def visit_integrations(archive)
    visit_archive(archive.slug)
    visit staff_archive_integrations_path(archive)
    page.should have_content("Integrations")
  end
    

  def create_page(archive, page_title, page_body)
    visit_archive(archive.slug)
    within(:xpath, "//fieldset[@id='page-management']") do
      click_link("+")
    end

    fill_in("page_title", :with => page_title)
    fill_in("page_body_editor", :with => page_body)
    click_button("Create Page")
  end

  def create_news(archive, news_title, news_body)
    visit(new_staff_news_path)
    fill_in("news_title", :with => news_title)
    check(archive.name)
    fill_in("news_body_editor", :with => news_body)
    click_button("Create News")
    current_path.sub(%r{.*/},'').to_i
  end

  def upload_image(file_title, file_path)
    visit(new_staff_image_path)
    fill_in("image_title", :with => file_title)
    attach_file("image_resource", file_path)
    click_button("Create Image")
    current_path.sub(%r{.*/},'').to_i
  end

  def upload_document(file_title, file_path)
    visit(new_staff_document_path)
    fill_in("document_title", :with => file_title)
    attach_file("document_resource", file_path)
    click_button("Create Document")
    current_path.sub(%r{.*/},'').to_i
  end

  def sign_in(user)
    login_as user
    user.openid_fields=({"http://users.ada.edu.au/role" => user.roles.first.name})
    visit("/staff/home")
  end

  def sign_out
    visit logout_path
  end
  
  #copied from application_helper
  def first_n_words(n, words)
    return if words.nil?
    words = words.gsub(/(<\/?[^>]*>|&[a-z]*;)/, " ").split(/\W/m).reject{|w| w.empty? }
    words = words.size > n ? words[0...n]+['...'] : words
    words * ' '
  end
  
  #this is solely here to run searches more easily from the debug console
  def searcher(term)
    Sunspot.search(Study) do ;
      keywords term do 
        highlight :label
      end
    end
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
