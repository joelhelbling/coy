require 'spec_helper'
require 'coy/operation'

module Coy
  describe Operation do
    before do
      Gitignore.stub(:guard_ignorance)
    end

    subject { Operation.new coy_action, coy_params }

    describe "create" do

      context "required params only" do
        let(:coy_action) { :create }

        let(:coy_params) do
          {
            name:      'foo',
            password:  'b@r'
          }
        end

        let(:tc_params) do
          {
            name:           'foo',
            short_name:     'foo',
            file_name:      '.coy/foo.tc',
            size_in_bytes:  2_000_000,
            encryption:     'AES',
            hash:           'Whirlpool',
            filesystem:     'FAT',
            password:       'b@r',
            keyfiles:       '""'
          }
        end

        it "creates a volume" do
          TrueCrypt.should_receive(:create_volume).with(tc_params)
          subject.go
        end
      end

    end

    describe "open" do
      let(:coy_action) { :open }

      let(:coy_params) do
        {
          name:      'foo',
          password:  'b@r'
        }
      end

      let(:tc_params) do
        {
          name:        'foo',
          short_name:  'foo',
          file_name:   '.coy/foo.tc',
          password:    'b@r'
        }
      end

      it "opens a volume" do
        TrueCrypt.should_receive(:open).with(tc_params)
        subject.go
      end
    end

    describe "close" do
      let(:coy_action) { :close }

      let(:coy_params) do
        {
          name:  'foo'
        }
      end

      let(:tc_params) do
        {
          name:        'foo',
          short_name:  'foo',
          file_name:   '.coy/foo.tc',
          password:    nil
        }
      end

      it "closes a volume" do
        TrueCrypt.should_receive(:close).with(tc_params)
        subject.go
      end
    end

  end
end
