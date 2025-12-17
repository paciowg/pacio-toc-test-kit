# @note includes RSpec shared context 'when testing a runnable'
RSpec.describe PacioTOCTestKit::PacioTOCV100::PatientGroup do
  let(:suite_id) { 'toc_v100' }
  let(:group) { suite.groups.find { |g| g.id.include?(described_class.id) } }
  let(:url) { 'http://example.com/fhir' }
  let(:patient_id) { 'patient-1' }
  let(:patient) do
    FHIR::Patient.new(id: patient_id)
  end
  let(:success_outcome) do
    {
      outcomes: [{
        issues: []
      }],
      sessionId: test_session.id
    }
  end
  let(:error_outcome) do
    {
      outcomes: [{
        issues: [{
          location: 'Patient.identifier[0]',
          message: 'Identifier.system must be an absolute reference, not a local reference',
          level: 'ERROR'
        }]
      }],
      sessionId: test_session.id
    }
  end

  describe 'read test' do
    let(:test) { group.tests.find { |t| t.id.include?(PacioTOCTestKit::PacioTOCV100::PatientReadTest.id) } }

    before do
      allow_any_instance_of(test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )
    end

    it 'passes if a Patient was received' do
      stub_request(:get, "#{url}/Patient/#{patient_id}")
        .to_return(status: 200, body: patient.to_json)

      result = run(test, url: url)

      expect(result.result).to eq('pass')
    end

    it 'fails if a 200 is not received' do
      stub_request(:get, "#{url}/Patient/#{patient_id}")
        .to_return(status: 400, body: patient.to_json)

      result = run(test, url: url)

      expect(result.result).to eq('fail')
      expect(result.result_message).to match(/200/)
    end

    it 'fails if the id received does not match the one requested' do
      resource = FHIR::Patient.new(id: '456')
      stub_request(:get, "#{url}/Patient/#{patient_id}")
        .to_return(status: 200, body: resource.to_json)

      result = run(test, url: url)

      expect(result.result).to eq('fail')
      expect(result.result_message).to match(/resource to have id/)
    end
  end

  describe 'validation test' do
    let(:test) { group.tests.find { |t| t.id.include?(PacioTOCTestKit::PacioTOCV100::PatientValidationTest.id) } }

    before do
      allow_any_instance_of(test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )
    end

    it 'passes if the resource is valid' do
      stub_request(:post, validation_url)
        .with(query: hash_including({}))
        .to_return(status: 200, body: success_outcome.to_json)

      resource = FHIR::Patient.new
      repo_create(
        :request,
        name: :patient,
        test_session_id: test_session.id,
        response_body: resource.to_json
      )

      result = run(test, url: url)

      expect(result.result).to eq('pass')
    end

    it 'fails if the resource is not valid' do
      stub_request(:post, validation_url)
        .with(query: hash_including({}))
        .to_return(status: 200, body: error_outcome.to_json)

      resource = FHIR::Patient.new
      repo_create(
        :request,
        name: :patient,
        test_session_id: test_session.id,
        response_body: resource.to_json
      )

      result = run(test, url: url)

      expect(result.result).to eq('fail')
    end
  end
end
