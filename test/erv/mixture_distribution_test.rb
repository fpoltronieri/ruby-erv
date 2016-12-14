require 'test_helper'

require 'erv/mixture_distribution'

describe ERV::MixtureDistribution do
  it 'should require at least two distributions' do
    lambda do
      ERV::MixtureDistribution.new([ { distribution: :exponential, rate: 1.0, weight: 0.5 } ])
    end.must_raise ArgumentError
  end

  it 'should keep track of distribution weights (for normalization)' do
    # create a mixture distribution with unnormalized weights
    uw_md = ERV::MixtureDistribution.new([ { distribution: :exponential, rate: 1.0, weight: 100.0 },
                                           { distribution: :exponential, rate: 2.0, weight: 200.0 },
                                           { distribution: :exponential, rate: 3.0, weight: 300.0 } ])
    uw_md.instance_variable_get("@weight_sum").must_equal 600.0
  end

  let :md do
    ERV::MixtureDistribution.new([ { distribution: :exponential, rate: 1.0, weight: 0.3 },
                                   { distribution: :exponential, rate: 2.0, weight: 0.2 },
                                   { distribution: :exponential, rate: 3.0, weight: 0.5 } ])
  end

  context 'sampling' do

    it 'should allow sampling from the mixture' do
      md.sample
    end

  end

  context 'moments' do

    let :expected_mean do
      0.3 * 1/1.0 + 0.2 * 1/2.0 + 0.5 * 1/3.0
    end

    let :expected_variance do
      0.3 * (1/1.0 - expected_mean) ** 2 + (1/1.0) ** 2 +
      0.2 * (1/2.0 - expected_mean) ** 2 + (1/2.0) ** 2 +
      0.5 * (1/3.0 - expected_mean) ** 2 + (1/3.0) ** 2
    end

    it 'should correctly calculate the mean of the mixture' do
      md.mean.must_equal expected_mean
    end

    it 'should correctly calculate the variance of the mixture' do
      md.mean.must_equal expected_mean
    end

  end
end
