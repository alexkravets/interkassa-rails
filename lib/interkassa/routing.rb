module ActionDispatch::Routing
  class Mapper
    def mount_interkassa_callbacks
      scope "/ik", :module => "interkassa" do
        post 'success'     => 'callbacks#success'
        post 'fail'        => 'callbacks#fail'
        # pending request considered as fail
        post 'pending'     => 'callbacks#fail'
        constraints(ip: /85\.10\.225\.\d+/) do
          post 'interaction' => 'callbacks#interaction'
        end
      end
    end
  end
end