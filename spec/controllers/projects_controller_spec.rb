require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "GET #index" do
  define_models

  act! { get :index }

  before do
    @account  = accounts(:default)
    @projects = []
    @account.stub!(:projects).and_return(@projects)
    controller.stub!(:account).and_return(@account)
  end
  
  it.assigns :projects
  it.renders :template, :index

  describe ProjectsController, "(xml)" do
    define_models
    
    act! { get :index, :format => 'xml' }

    it.assigns :projects
    it.renders :xml, :projects
  end
end

describe ProjectsController, "GET #show" do
  define_models

  act! { get :show, :id => 1 }

  before do
    @account = accounts(:default)
    @project = projects(:default)
    @account.stub!(:projects).and_return([])
    @account.projects.stub!(:find).with('1').and_return(@project)
    controller.stub!(:account).and_return(@account)
  end
  
  it.assigns :project
  it.renders :template, :show
  
  describe ProjectsController, "(xml)" do
    define_models
    
    act! { get :show, :id => 1, :format => 'xml' }

    it.renders :xml, :project
  end
end

describe ProjectsController, "GET #new" do
  define_models
  act! { get :new }
  before do
    @project  = Project.new
  end

  it "assigns @project" do
    act!
    assigns[:project].should be_new_record
  end
  
  it.renders :template, :new
  
  describe ProjectsController, "(xml)" do
    define_models
    act! { get :new, :format => 'xml' }

    it.renders :xml, :project
  end
end

describe ProjectsController, "GET #edit" do
  define_models
  act! { get :edit, :id => 1 }
  
  before do
    @account = accounts(:default)
    @project = projects(:default)
    @account.stub!(:projects).and_return([])
    @account.projects.stub!(:find).with('1').and_return(@project)
    controller.stub!(:account).and_return(@account)
  end

  it.assigns :project
  it.renders :template, :edit
end

describe ProjectsController, "POST #create" do
  before do
    @attributes = {}
    @project = mock_model Project, :new_record? => false, :errors => []
    @account = accounts(:default)
    @account.stub!(:projects).and_return([])
    @account.projects.stub!(:build).with(@attributes).and_return(@project)
    controller.stub!(:account).and_return(@account)
  end
  
  describe ProjectsController, "(successful creation)" do
    define_models
    act! { post :create, :project => @attributes }

    before do
      @project.stub!(:save).and_return(true)
    end
    
    it.assigns :project, :flash => { :notice => :not_nil }
    it.redirects_to { project_path(@project) }
  end

  describe ProjectsController, "(unsuccessful creation)" do
    define_models
    act! { post :create, :project => @attributes }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it.assigns :project
    it.renders :template, :new
  end
  
  describe ProjectsController, "(successful creation, xml)" do
    define_models
    act! { post :create, :project => @attributes, :format => 'xml' }

    before do
      @project.stub!(:save).and_return(true)
      @project.stub!(:to_xml).and_return("mocked content")
    end
    
    it.assigns :project, :headers => { :Location => lambda { project_url(@project) } }
    it.renders :xml, :project, :status => :created
  end
  
  describe ProjectsController, "(unsuccessful creation, xml)" do
    define_models
    act! { post :create, :project => @attributes, :format => 'xml' }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it.assigns :project
    it.renders :xml, "project.errors", :status => :unprocessable_entity
  end
end

describe ProjectsController, "PUT #update" do
  before do
    @attributes = {}
    @account = accounts(:default)
    @project = projects(:default)
    @account.stub!(:projects).and_return([])
    @account.projects.stub!(:find).with('1').and_return(@project)
    controller.stub!(:account).and_return(@account)
  end
  
  describe ProjectsController, "(successful save)" do
    define_models
    act! { put :update, :id => 1, :project => @attributes }

    before do
      @project.stub!(:save).and_return(true)
    end
    
    it.assigns :project, :flash => { :notice => :not_nil }
    it.redirects_to { project_path(@project) }
  end

  describe ProjectsController, "(unsuccessful save)" do
    define_models
    act! { put :update, :id => 1, :project => @attributes }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it.assigns :project
    it.renders :template, :edit
  end
  
  describe ProjectsController, "(successful save, xml)" do
    define_models
    act! { put :update, :id => 1, :project => @attributes, :format => 'xml' }

    before do
      @project.stub!(:save).and_return(true)
    end
    
    it.assigns :project
    it.renders :blank
  end
  
  describe ProjectsController, "(unsuccessful save, xml)" do
    define_models
    act! { put :update, :id => 1, :project => @attributes, :format => 'xml' }

    before do
      @project.stub!(:save).and_return(false)
    end
    
    it.assigns :project
    it.renders :xml, "project.errors", :status => :unprocessable_entity
  end
end

describe ProjectsController, "DELETE #destroy" do
  define_models
  act! { delete :destroy, :id => 1 }
  
  before do
    @account = accounts(:default)
    @project = projects(:default)
    @project.stub!(:destroy)
    @account.stub!(:projects).and_return([])
    @account.projects.stub!(:find).with('1').and_return(@project)
    controller.stub!(:account).and_return(@account)
  end

  it.assigns :project
  it.redirects_to { projects_path }
  
  describe ProjectsController, "(xml)" do
    define_models
    act! { delete :destroy, :id => 1, :format => 'xml' }

    it.assigns :project
    it.renders :blank
  end
end