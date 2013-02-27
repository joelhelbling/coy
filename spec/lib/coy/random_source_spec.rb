require 'spec_helper'
require 'coy/random_source'

module Coy
  describe RandomSource do
    subject { described_class }

    its(:generate) { should_not be_empty }

    specify "each run should be different" do
      subject.generate.should_not == subject.generate
    end

    describe "::generate" do
      context "with a code block", :fakefs do
        let(:file_name) { './foo.random' }
        context "but no file name" do
          it "provides a default file name" do
            expect { |b| subject.generate(&b) }.to yield_with_args(Coy::RandomSource::DEFAULT_FILE)
          end
        end
        context "with file name provided" do
          it "uses the provided file name" do
            expect { |b| subject.generate(file_name, &b) }.to yield_with_args(file_name)
          end
        end

        describe "generating random source file" do
          it "writes the file to the hard drive" do
            subject.generate(file_name) do |f_name|
              File.new(f_name).should exist
            end
          end

          it "deletes the file after yielding to the block" do
            subject.generate(file_name) do |f_name|
              File.new(f_name).should exist
            end
            File.exists?(file_name).should be_false
          end
        end
      end

    end

  end
end
