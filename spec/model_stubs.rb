ModelStubbing.define_models do
  time 2007, 6, 15

  model Account do
    stub :host => 'project'
  end

  model User do
    stub :login => 'normal-user', :email => 'normal-user@example.com', :state => 'active',
      :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :created_at => current_time - 5.days, :remember_token => 'foo-bar', :remember_token_expires_at => current_time + 5.days,
      :activation_code => '8f24789ae988411ccf33ab0c30fe9106fab32e9b', :activated_at => current_time - 4.days, :account => all_stubs(:account)
  end
  
  model Project do
    stub :name => 'project', :billable => true, :account => all_stubs(:account)
  end
  
  model Status do
    stub :user => all_stubs(:user), :message => 'foo', :state => 'processed', :hours => 5, :created_at => current_time - 2.days, :project => all_stubs(:project)
  end
end

ModelStubbing.define_models :users do 
  model User do
    stub :admin,     :login => 'admin-user',     :email => 'admin-user@example.com', :remember_token => 'blah'
    stub :pending,   :login => 'pending-user',   :email => 'pending-user@example.com',   :state => 'pending', :activated_at => nil, :remember_token => 'asdf', :activation_code => 'abcdef'
    stub :suspended, :login => 'suspended-user', :email => 'suspended-user@example.com', :state => 'suspended', :remember_token => 'dfdfd'
  end
end

ModelStubbing.define_models :statuses do
  model Status do
    stub :pending, :state => 'pending', :hours => 0, :created_at => current_time - 5.hours
  end
end

ModelStubbing.define_models :stubbed, :insert => false