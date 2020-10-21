module Transbank
  module Webpay
    module Oneclick
      class MallDeferredInscription < Transbank::Webpay::Oneclick::MallInscription
        extend Transbank::Utils::NetHelper

        class << self
          def default_integration_params
            {
              api_key: Oneclick::Base::DEFAULT_API_KEY,
              commerce_code: Oneclick::Base::DEFAULT_ONECLICK_MALL_DEFERRED_COMMERCE_CODE,
              integration_type: Oneclick::Base::integration_type,
              base_url: Oneclick::Base::current_integration_type_url
            }
          end
        end
      end
    end
  end
end
