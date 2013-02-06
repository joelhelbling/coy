require 'spec_helper'
require 'coy/gitignore'

module Coy
  describe Gitignore do

    before do
      Dir.stub(  :exists?   ).and_return( repo_existing      )
      File.stub( :exists?   ).and_return( gitignore_existing )
      File.stub( :readlines ).and_return( gitignore_contents )
    end

    let(:vol_name)           { "foo" }
    let(:repo_existing)      { false }
    let(:gitignore_existing) { false }
    let(:gitignore_contents) { []    }

    subject { Gitignore } # very classy!

    describe "::guard_ignorance" do

      describe "when the project IS a git repo" do
        let(:repo_existing) { true }

        context "and the .gitignore file" do
          context "does NOT exist" do
            let(:gitignore_existing) { false }
            specify "NoGitignoreFile IS raised" do
              expect { subject.guard_ignorance(vol_name) }.to raise_error NoGitignoreFile
            end
          end

          context "DOES exist" do
            let(:gitignore_existing) { true }
            specify "NoGitignoreFile is NOT raised" do
              expect { subject.guard_ignorance(vol_name) }.to_not raise_error NoGitignoreFile
            end

            context "but doesn't include .coy" do
              let(:gitignore_contents) { [] }

              specify "CoyNotIgnored IS raised" do
                expect { subject.guard_ignorance(vol_name) }.to raise_error CoyNotIgnored
              end
            end

            context "and does include .coy" do
              let(:gitignore_contents) { [".coy\n"] }

              specify "CoyNotIgnored is NOT raised" do
                expect { subject.guard_ignorance(vol_name) }.to_not raise_error CoyNotIgnored
              end
            end

            context "but doesn't include the protected dir" do
              let(:gitignore_contents) { [".coy\n"] }

              specify "ProtectedDirNotIgnored IS raised" do
                expect { subject.guard_ignorance(vol_name) }.to raise_error ProtectedDirNotIgnored
              end
            end

            context "and does include the protected dir" do
              let(:gitignore_contents) { [".coy\n", "#{vol_name}\n"] }

              specify "ProtectedDirNotIgnored is NOT raised" do
                expect { subject.guard_ignorance(vol_name) }.to_not raise_error ProtectedDirNotIgnored
              end
            end
          end
        end

      end

      describe "when the project is NOT a git repo" do
        let(:repo_existing) { false }

        context "even if the .gitignore file" do
          context "doesn't exist" do
            let(:gitignore_existing) { false }
            specify "NoGitignoreFile is NOT raised" do
              expect { subject.guard_ignorance(vol_name) }.to_not raise_error NoGitignoreFile
            end
          end
        end
      end

    end
  end
end
