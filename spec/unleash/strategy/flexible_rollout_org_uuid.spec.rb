# frozen_string_literal: true

require 'spec_helper'
require 'unleash/strategy/flexible_rollout_org_uuid'

RSpec.describe Unleash::Strategy::FlexibleRolloutOrgUUID do
  describe '#is_enabled?' do
    let(:strategy) { Unleash::Strategy::FlexibleRolloutOrgUUID.new }
    let(:unleash_context) { Unleash::Context.new }

    it 'should always be enabled when rollout is set to 100, disabled when set to 0' do
      params = {
        'groupUUID' => 'Demo',
        'rollout' => 100,
        'stickiness' => 'default'
      }

      expect(strategy.is_enabled?(params, unleash_context)).to be_truthy
      expect(strategy.is_enabled?(params.merge({ 'rollout' => 0 }), unleash_context)).to be_falsey
    end

    it 'should behave predictably when based on the normalized_number' do
      allow(Unleash::Strategy::Util).to receive(:get_normalized_number).and_return(15)

      params = {
        'groupUUID' => 'Demo',
        'stickiness' => 'default'
      }

      expect(strategy.is_enabled?(params.merge({ 'rollout' => 14 }), unleash_context)).to be_falsey
      expect(strategy.is_enabled?(params.merge({ 'rollout' => 15 }), unleash_context)).to be_truthy
      expect(strategy.is_enabled?(params.merge({ 'rollout' => 16 }), unleash_context)).to be_truthy
    end
  end
end
