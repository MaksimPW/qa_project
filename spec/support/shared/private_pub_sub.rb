shared_examples_for 'Able PrivatePub' do
  context 'PrivatePub' do
    it 'should receive publish_to' do
      expect(PrivatePub).to receive(:publish_to)
      do_request
    end
  end
end

shared_examples_for 'Disable PrivatePub' do
  context 'PrivatePub' do
    it 'should not receive publish_to' do
      expect(PrivatePub).to_not receive(:publish_to)
      do_request
    end
  end
end