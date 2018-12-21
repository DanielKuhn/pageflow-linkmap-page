require 'spec_helper'

module Pageflow
  module LinkmapPage
    describe AreasHelper do
      describe '#linkmap_area_divs' do
        it 'renders div with attribute name as class' do
          entry = create(:entry)
          configuration = {}

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('div.linkmap_areas')
        end

        it 'renders linkmap areas' do
          entry = create(:entry)
          configuration = {'linkmap_areas' => [{}]}

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('div a[href]')
        end

        it 'renders hover image inside linkmap areas' do
          entry = create(:entry)
          configuration = {'linkmap_areas' => [{}], 'hover_image_id' => 5}

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('a div[class~="image_panorama_5"]')
        end

        it 'renders masked hover image inside masked linkmap areas' do
          entry = create(:entry)
          color_map_file = create(:color_map_file)
          masked_image_file = create(:masked_image_file)
          configuration = {
            'linkmap_areas' => [{'color_map_component_id' => "#{color_map_file.id}:aaa"}],
            'hover_image_id' => 5,
            'linkmap_color_map_file_id' => color_map_file.id,
            'linkmap_masked_hover_image_id' => masked_image_file.id
          }

          html = helper.linkmap_areas_div(entry, configuration)

          image_class = "pageflow_linkmap_page_masked_image_file_aaa_#{masked_image_file.id}"
          expect(html).to have_selector("a div[class~=#{image_class}]")
        end

        it 'only uses masked hover image if area is masked' do
          entry = create(:entry)
          masked_image_file = create(:masked_image_file)
          configuration = {
            'linkmap_areas' => [{}],
            'hover_image_id' => 5,
            'linkmap_masked_hover_image_id' => masked_image_file.id
          }

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('a div[class~="image_panorama_5"]')
        end

        it 'does not use masked hover image if area color map component id references other image' do
          entry = create(:entry)
          masked_image_file = create(:masked_image_file)
          color_map_file = create(:color_map_file)
          other_id = color_map_file.id + 1
          configuration = {
            'linkmap_areas' => [{'color_map_component_id' => "#{other_id}:aaa"}],
            'hover_image_id' => 5,
            'linkmap_masked_hover_image_id' => masked_image_file.id
          }

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('a div[class~="image_panorama_5"]')
        end

        it 'renders visited image inside linkmap areas' do
          entry = create(:entry)
          configuration = {'linkmap_areas' => [{}], 'visited_image_id' => 5}

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('a div[class~="image_panorama_5"]')
        end

        it 'renders masked visited image inside masked linkmap areas' do
          entry = create(:entry)
          color_map_file = create(:color_map_file)
          masked_image_file = create(:masked_image_file)
          configuration = {
            'linkmap_areas' => [{'color_map_component_id' => "#{color_map_file.id}:aaa"}],
            'hover_image_id' => 5,
            'linkmap_color_map_file_id' => color_map_file.id,
            'linkmap_masked_visited_image_id' => masked_image_file.id
          }

          html = helper.linkmap_areas_div(entry, configuration)

          image_class = "pageflow_linkmap_page_masked_image_file_aaa_#{masked_image_file.id}"
          expect(html).to have_selector("a div[class~='#{image_class}']")
        end

        it 'sets data-color-map-component-id attribute if area has color_map_component_id' do
          entry = create(:entry)
          configuration = {'linkmap_areas' => [{'color_map_component_id' => '1:aaa'}]}

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector('a[data-color-map-component-id="1:aaa"]')
        end

        it 'uses color map component id if present, preceding mask perma id' do
          entry = create(:entry)
          color_map_file_1 = create(:color_map_file)
          color_map_file_2 = create(:color_map_file)
          configuration = {
            'linkmap_areas' => [{'color_map_component_id' => "#{color_map_file_2.id}:aaa",
                                 'mask_perma_id' => "#{color_map_file_1.id}:aaa"}]
          }

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector("a[data-color-map-component-id='#{color_map_file_2.id}:aaa']")
        end

        it 'uses mask perma id as fallback if present and color map component id is blank' do
          entry = create(:entry)
          color_map_file = create(:color_map_file)
          configuration = {
            'linkmap_areas' => [{'mask_perma_id' => "#{color_map_file.id}:aaa"}]
          }

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).to have_selector("a[data-color-map-component-id='#{color_map_file.id}:aaa']")
        end

        it 'does not set data-color-map-component-id attribute if background type is hover_video' do
          entry = create(:entry)
          configuration = {
            'linkmap_areas' => [{'color_map_component_id' => '1:aaa'}],
            'background_type' => 'hover_video'
          }

          html = helper.linkmap_areas_div(entry, configuration)

          expect(html).not_to have_selector('a[data-color-map-component-id]')
        end
      end

      describe '#linkmap_area' do
        it 'renders link tag' do
          entry = create(:entry)

          html = helper.linkmap_area(entry, {}, 0)

          expect(html).to have_selector('a[href]')
        end

        it 'sets inline styles for position and size' do
          entry = create(:entry)
          attributes = {top: 20, left: 30, width: 40, height: 50}

          html = helper.linkmap_area(entry, attributes, 0)

          expect(html).to include('top: 20%;')
          expect(html).to include('left: 30%;')
          expect(html).to include('width: 40%;')
          expect(html).to include('height: 50%;')
        end

        it 'sets data attribute for audio file' do
          entry = create(:entry)
          attributes = {target_type: 'audio_file', target_id: 25}

          html = helper.linkmap_area(entry, attributes, 5)

          expect(html).to have_selector('a[data-audio-file="25.area_5"]')
        end

        it 'sets data attribute for page link' do
          entry = create(:entry)
          attributes = {target_type: 'page', target_id: 10}

          html = helper.linkmap_area(entry, attributes, 0)

          expect(html).to have_selector('a[data-target-id="10"]')
        end
      end
    end
  end
end
