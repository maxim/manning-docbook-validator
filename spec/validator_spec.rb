require 'manning-docbook-validator'

describe 'validator' do
  before do
    FileUtils.rm_rf("spec/fixtures")
    FileUtils.mkdir_p("spec/fixtures")
  end

  let(:path) { "spec/fixtures/example.xml" }

  context 'errors on' do
    context 'duplicate id attributes' do
      before do
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.chapter do
            xml.para(:id => "ch01_1") { "content" }
            xml.para(:id => "ch01_1") { "other content" }
            xml.para(:id => "ch01_1") { "more content" }
          end
        end

        File.open(path, "w+") do |f|
          f.write builder.to_xml
        end
      end

      let(:validator) do
        Manning::Docbook::Validator.new(path).validate!
      end

      specify do
        validator.errors.count.should == 2
        validator.errors[0].message.should == "Duplicate id located on line #4: ch01_1. First seen on line #3."
        validator.errors[1].message.should == "Duplicate id located on line #5: ch01_1. First seen on line #3."
      end

    end

    context 'listing lines over 72 characters' do
      before do
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.chapter do
            # FAIL
            xml.informalexample(:id => "ch01_1") do
              xml.programlisting do
                xml.text "*" * 73
              end
            end

            # FAIL
            xml.example(:id => "ch01_2") do
              xml.programlisting do
                xml.text "*" * 73
              end
            end

            # OK
            xml.informalexample(:id => "ch01_3") do
              xml.programlisting do
                xml.text "*" * 72
              end
            end

            # OK
            xml.example(:id => "ch01_4") do
              xml.programlisting do
                xml.text "*" * 72
              end
            end

            # OK
            # Manning's own parser is a bit of a jerk about this.
            # They are checking full-line-lengths probably using Regex or some other BS
            # A callout doesn't count as an "official" count, so it should be ignored.
            xml.example(:id => "ch01_5") do
              xml.programlisting do
                xml.text ("*" * 72) + "\n"
                xml.co(:id => "ch01_4_1")
                xml.text(("*" * 72) + "\n" +
                          ("*" * 72) + "\n" +
                          ("*" * 72) + "\n")
              end
            end
          end
        end

        File.open(path, "w+") do |f|
          f.write builder.to_xml
        end
      end

      let(:validator) do
        Manning::Docbook::Validator.new(path).validate!
      end

      specify do
        validator.errors.count.should == 2
        validator.errors[0].message.should == "Code on line 1 of informalexample#ch01_1 is too long. Line limit is 72 characters."
        validator.errors[1].message.should == "Code on line 1 of example#ch01_2 is too long. Line limit is 72 characters."
      end


    end
  end
end
