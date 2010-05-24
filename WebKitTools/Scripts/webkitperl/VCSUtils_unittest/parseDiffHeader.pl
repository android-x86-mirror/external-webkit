# The unit tests for parseGitDiffHeader() and parseSvnDiffHeader()
# already thoroughly test parsing each format.
#
# For parseDiffHeader(), it should suffice to verify that -- (1) for each
# format, the method can return non-trivial values back for each key
# supported by that format (e.g. "sourceRevision" for SVN), (2) the method
# correctly sets default values when specific key-values are not set
# (e.g. undef for "sourceRevision" for Git), and (3) key-values unique to
# this method are set correctly (e.g. "scmFormat").
####
#    SVN test cases
##
{   # New test
    diffName => "SVN: non-trivial copiedFromPath and sourceRevision values",
    expectedReturn => [
{
    isSvn => 1,
"@@ -0,0 +1,7 @@\n"],
    expectedNextLine => "+# Python file...\n",
####
#    Git test cases
##
{   # New test case
    diffName => "Git: Non-zero executable bit",
diff --git a/foo.exe b/foo.exe
old mode 100644
new mode 100755
    expectedReturn => [
Index: foo.exe
old mode 100644
new mode 100755
    executableBitDelta => 1,
    indexPath => "foo.exe",
    isGit => 1,
undef],
    expectedNextLine => undef,
my $testCasesCount = @testCaseHashRefs;
plan(tests => 2 * $testCasesCount); # Total number of assertions.
foreach my $testCase (@testCaseHashRefs) {
    my $testNameStart = "parseDiffHeader(): $testCase->{diffName}: comparing";
    my $fileHandle;
    open($fileHandle, "<", \$testCase->{inputText});
    my @got = VCSUtils::parseDiffHeader($fileHandle, $line);
    my $expectedReturn = $testCase->{expectedReturn};
    is_deeply(\@got, $expectedReturn, "$testNameStart return value.");
    my $gotNextLine = <$fileHandle>;
    is($gotNextLine, $testCase->{expectedNextLine},  "$testNameStart next read line.");