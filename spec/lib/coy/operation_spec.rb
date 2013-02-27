require 'spec_helper'
require 'coy/operation'

module Coy
  describe Operation do
    before do
      Ignorance.stub(:negotiate)
      TrueCrypt.stub(:create_volume)
      TrueCrypt.stub(:open)
      TrueCrypt.stub(:close)
      TrueCrypt.stub(:installed?).and_return(true)
    end

    let(:volume) { 'foo' }
    subject { Operation.new coy_action, coy_params }

    context "when TrueCrypt is not installed" do
      let(:coy_action) { :doesnt_matter }
      let(:coy_params) { { name: volume } }

      before { TrueCrypt.stub(:installed?).and_return(false) }

      specify do
        expect { subject }.to raise_error /truecrypt.*?not installed/i
      end
    end

    describe ":create" do

      context "required params only" do
        let(:coy_action) { :create }

        let(:coy_params) do
          {
            name:      volume,
            password:  'b@r'
          }
        end

        let(:tc_params) do
          {
            name:           volume,
            short_name:     volume,
            file_name:      ".coy/#{volume}.tc",
            size_in_bytes:  2_000_000,
            encryption:     'AES',
            hash:           'Whirlpool',
            filesystem:     'FAT',
            password:       'b@r',
            keyfiles:       '""',
            random_source:  "./.coy/#{volume}.random"
          }
        end

        it "creates a volume" do
          TrueCrypt.should_receive(:create_volume).with(tc_params)
          subject.go
        end

        it "negotiates adding the coy directory to ignore file" do
          Ignorance.should_receive(:negotiate).with('.coy', Operation::COY_COMMENT)
          subject.go
        end

        it "negotiates adding volume to ignore files" do
          Ignorance.should_receive(:negotiate).with(volume, Operation::COY_COMMENT)
          subject.go
        end
      end

    end

    describe ":open", :fakefs do
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

      before do
        Dir.mkdir '.coy'
        File.open(".coy/#{volume}.tc", 'w') {|fh| fh.write "whatnot" }
      end

      it "opens a volume" do
        TrueCrypt.should_receive(:open).with(tc_params)
        subject.go
      end

      it "negotiates adding the coy directory to ignore file" do
        Ignorance.should_receive(:negotiate).with('.coy', Operation::COY_COMMENT)
        subject.go
      end

      it "negotiates adding volume to ignore files" do
        Ignorance.should_receive(:negotiate).with(volume, Operation::COY_COMMENT)
        subject.go
      end
    end

    describe ":close", :fakefs do
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

      before do
        Dir.mkdir '.coy'
        File.open(".coy/#{volume}.tc", 'w') {|fh| fh.write "whatnot" }
      end

      it "closes a volume" do
        TrueCrypt.should_receive(:close).with(tc_params)
        subject.go
      end

      it "negotiates adding the coy directory to ignore file" do
        Ignorance.should_receive(:negotiate).with('.coy', Operation::COY_COMMENT)
        subject.go
      end

      it "negotiates adding volume to ignore files" do
        Ignorance.should_receive(:negotiate).with(volume, Operation::COY_COMMENT)
        subject.go
      end
    end

    describe "guarding against non-existant volume", :fakefs, :capture_io do
      context "volume doesn't exist" do
        let(:volume_name) { 'foo' }
        let(:coy_params) { { name: volume_name } }

        describe ":open" do
          let(:coy_action) { :open }

          it "advises user to create volume" do
            expect( output_from { subject.go } ).to match /create.*?#{volume_name}/i
          end
        end

        describe ":close" do
          let(:coy_action) { :close }

          it "advises user to create volume" do
            expect( output_from { subject.go } ).to match /create.*?#{volume_name}/i
          end
        end
      end
    end

    context "when user omits password in command-line", :fakefs, :capture_io do
      let(:coy_params) { { name: volume } }

      before do
        Dir.mkdir '.coy'
        File.open(".coy/#{volume}.tc", 'w') { |fh| fh.write "whatnot" }
      end

      describe ":create" do
        let(:coy_action) { :create }

        it "asks user to provide a password" do
          expect( user_types("p@55w0rd") { subject.go } ).to match /provide.*?password.*?#{volume}/i
        end
      end

      describe ":open" do
        let(:coy_action) { :open }

        it "prompts user for volume password" do
          expect( user_types("p@55w0rd") { subject.go } ).to match /enter.*?password.*?#{volume}/i
        end
      end
    end

  end
end
