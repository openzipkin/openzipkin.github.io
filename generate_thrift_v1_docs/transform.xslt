<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.w3.org/1999/xhtml">
  <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>

  <!-- identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Set title -->
  <xsl:template match="/html/head/title">
    <title>Zipkin V1 Thrift models</title>
  </xsl:template>
  <xsl:template match="//h1">
    <h1>Zipkin V1 Thrift models</h1>
  </xsl:template>

  <!-- Remove the fake "wrapper" module from the output -->
  <xsl:template match="//tr[td[text()='wrapper']]"/>
</xsl:stylesheet>
