require 'swagger_helper'

describe 'Menu Items API', swagger: true do
  include_context 'Platform API v2'

  resource_name = 'MenuItem'
  include_example = 'linked_resource'

  let(:menu) { create(:menu, store: store) }
  let(:id) { create(:menu_item, menu: menu).id }
  let!(:menu_item_one) { create(:menu_item, menu: menu) }
  let!(:menu_item_two) { create(:menu_item, menu: menu) }
  let!(:menu_item_three) { create(:menu_item, menu: menu) }

  let(:records_list) { create_list(:menu_item, 4, menu: menu) }
  let(:valid_create_param_value) { build(:menu_item, menu: menu).attributes }
  let(:valid_update_param_value) do
    {
      name: 'Menu Item One'
    }
  end
  let(:invalid_param_value) do
    {
      name: '',
    }
  end
  let(:valid_update_position_param_value) do
    {
      new_parent_id: menu_item_two.id,
      new_position_idx: 0
    }
  end

  include_examples 'CRUD examples', resource_name, include_example

  path '/api/v2/platform/menu_items/{id}/reposition' do
    patch 'Reposition a Menu Item' do
      tags resource_name.pluralize
      security [ bearer_auth: [] ]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :menu_item, in: :body, schema: { '$ref' => '#/components/schemas/menu_item_reposition_params' }

      let(:menu_item) { valid_update_position_param_value }
      let(:invalid_param_value) do
        {
          new_parent_id: 'invalid',
          new_position_idx: 'invalid'
        }
      end

      it_behaves_like 'record updated'
      it_behaves_like 'record not found', :menu_item
      it_behaves_like 'authentication failed'
    end
  end
end
