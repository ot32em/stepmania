<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sm="http://www.stepmania.com"
	exclude-result-prefixes="sm"> <!-- keep xslt from spittingout namespace info. -->
<!-- This could be xhtml 1.0 strict, but firefox is failing at xml -> xhtml, or something
 <xsl:output method="xml" encoding="UTF-8" version="1.0" standalone="yes"
	doctype-system="http://www.w3.org/TR/2000/REC-xhtml1-20000126/DTD/xhtml1-strict.dtd"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
-->
<!--<xsl:output method="html" encoding="UTF-8" version="4.01" standalone="yes"
	doctype-system="http://www.w3.org/TR/html4/strict.dtd"
	doctype-public="-//W3C//DTD HTML 4.01//EN" />-->
<xsl:output method="xml" encoding="UTF-8" version="1.0"
	doctype-system="http://www.w3.org/TR/2000/REC-xhtml1-20000126/DTD/xhtml1-strict.dtd"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	media-type="application/xhtml+xml"
	indent="yes"/>
<xsl:template match="/">
	<html>
		<head>
			<title>StepMania LUA Information</title>
			<style type="text/css">
				th {
					background-color: #CCCCFF;
					border-style: solid;
					border-width: thin;
					padding: 2px;
					font-size: 150%
				}
				table {
					border-style: ridge;
					border-collapse: collapse
				}
				td {
					padding: 2px;
					border-style: solid;
					border-width: thin
				}
				hr {
					width: 90%
				}
				code {
					font-family: monospace
				}
				.code {
					font-family: monospace
				}
				.returnTypeCell {
					font-family: monospace;
					text-align: right;
					vertical-align: text-top;
					width: 10em
				}
				.descriptionCell {
					font-family: monospace;
					text-align: justify;
					vertical-align: text-top
				}
				.descriptionName {
					font-family: monospace;
					font-weight: bold
				}
				.descriptionText {
					text-indent: 2em;
					margin-top: 0;
					margin-bottom: 0
				}
				.trigger {
					cursor: pointer
				}
				.footer {
					text-align: center
				}
			</style>
			<script type="text/javascript">
				function Open( id )
				{
					var imgid = 'img_' + id;
					var listid = 'list_' + id;
					var img = document.getElementById( imgid );
					var list = document.getElementById( listid );

					img.setAttribute( 'src', 'open.gif' );
					list.style.display = 'block';
				}
				function OpenAndMove( classid, functionid )
				{
					Open( classid );
					location.hash = classid + '_' + functionid;
				}
				function Toggle( id )
				{
					var imgid = 'img_' + id;
					var listid = 'list_' + id;
					var img = document.getElementById( imgid );
					var list = document.getElementById( listid );
					
					if( img.getAttribute('src') == 'closed.gif' )
					{
						img.setAttribute( 'src', 'open.gif' );
						list.style.display = 'block';
					}
					else
					{
						img.setAttribute( 'src', 'closed.gif' );
						list.style.display = 'none';
					}
				}
			</script>
		</head>
		<body>
			<xsl:apply-templates />
		</body>
	</html>
</xsl:template>


<xsl:template match="sm:Lua">
	<div>
		<h2>StepMania LUA Information</h2>
		<table>
			<tr>
				<th><a href="#Singletons">Singletons</a></th>
				<th><a href="#Classes">Classes</a></th>
				<th><a href="#GlobalFunctions">Global Functions</a></th>
				<th><a href="#Enums">Enums</a></th>
				<th><a href="#Constants">Constants</a></th>
			</tr>
		</table>
	</div>
	<xsl:apply-templates select="sm:Singletons" />
	<xsl:apply-templates select="sm:Classes" />
	<xsl:apply-templates select="sm:GlobalFunctions" />
	<xsl:apply-templates select="sm:Enums" />
	<xsl:apply-templates select="sm:Constants" />
	<hr />
	<p class="footer">
		Generated for <xsl:value-of select="sm:Version" /> on
		<xsl:value-of select="sm:Date" />.
	</p>
</xsl:template>


<xsl:template match="sm:Singletons">
	<div>
		<h3 id="Singletons">Singletons</h3>
		<ul>
			<xsl:for-each select="sm:Singleton">
				<xsl:sort select="@name" />
				<li>
					<a class="code" href="#{@class}" onclick="Open('{@class}')">
						<xsl:value-of select="@name" />
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</div>
</xsl:template>


<xsl:template match="sm:Classes">
	<div>
		<h3 id="Classes">Classes</h3>
		<xsl:apply-templates select="sm:Class">
			<xsl:sort select="@name" />
		</xsl:apply-templates>
	</div>
</xsl:template>

<xsl:variable name="docs" select="document('LuaDocumentation.xml')/sm:Documentation" />

<xsl:template match="sm:Class">
	<xsl:variable name="name" select="@name" />
	<div>
		<a id="{@name}" class="trigger" onclick="Toggle('{@name}')">
			<img src="closed.gif" id="img_{@name}" alt="" />
			Class <span class="descriptionName"><xsl:value-of select="@name" /></span>
		</a>
		<xsl:if test="@base != ''">
			<span class="code"><xsl:text> : </xsl:text></span>
			<a class="code" href="#{@base}" onclick="Open('{@base}')">
				<xsl:value-of select="@base" />
			</a>
		</xsl:if>
		<div style="display: none" id="list_{@name}">
		<table>
			<tr><th colspan="2">Member Functions</th></tr>
			<xsl:apply-templates select="sm:Function">
				<xsl:sort select="@name" />
				<xsl:with-param name="path" select="$docs/sm:Classes/sm:Class[@name=$name]" />
				<xsl:with-param name="class" select="$name" />
			</xsl:apply-templates>
		</table>
		<br />
		</div>
	</div>
</xsl:template>


<xsl:template match="sm:GlobalFunctions">
	<div>
		<h3 id="GlobalFunctions">Global Functions</h3>
		<table>
			<tr><th colspan="2">Functions</th></tr>
			<xsl:apply-templates select="sm:Function">
				<xsl:sort select="@name" />
				<xsl:with-param name="path" select="$docs/sm:GlobalFunctions" />
				<xsl:with-param name="class" select="'GLOBAL'" />
			</xsl:apply-templates>
		</table>
	</div>
</xsl:template>


<xsl:template match="sm:Function">
	<xsl:param name="path" />
	<xsl:param name="class" />
	<xsl:variable name="name" select="@name" />
	<xsl:variable name="elmt" select="$path/sm:Function[@name=$name]" />
	<tr id="{$class}_{$name}">
	<xsl:choose>
		<!-- Check for documentation. -->
		<xsl:when test="string($elmt/@name)=$name">
			<td class="returnTypeCell">
			<xsl:choose>
				<!-- XXX: /Lua/Classes/sm:Class[@name=$elmt/@return]
				          does not work and I have no idea why. -->
				<xsl:when test="boolean(//sm:Class[@name=$elmt/@return])">
					<a href="#{$elmt/@return}"
					   onclick="Open('{$elmt/@return}')">
						<xsl:value-of select="$elmt/@return" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$elmt/@return" />
				</xsl:otherwise>
			</xsl:choose>
			</td>
			<td class="descriptionCell">
			<span class="descriptionName"><xsl:value-of select="@name" /></span>( <xsl:value-of select="$elmt/@arguments" /> )
			<p class="descriptionText">
				<xsl:apply-templates select="$elmt" mode="print">
					<xsl:with-param name="class" select="$class" />
				</xsl:apply-templates>
			</p>
			</td>
		</xsl:when>
		<xsl:otherwise>
			<td class="returnTypeCell" />
			<td class="descriptionCell">
				<span class="descriptionName"><xsl:value-of select="@name" /></span>
			</td>
		</xsl:otherwise>
	</xsl:choose>
	</tr>
</xsl:template>
<xsl:template match="sm:Function" mode="print">
	<xsl:param name="class" />
	<xsl:apply-templates>
		<xsl:with-param name="curclass" select="$class" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="sm:Link">
	<xsl:param name="curclass" />
	<xsl:choose>
		<xsl:when test="string(@class)='' and string(@function)!=''">
			<a class="code" href="#{$curclass}_{@function}"><xsl:apply-templates /></a>
		</xsl:when>
		<xsl:when test="string(@class)!='' and string(@function)=''">
			<a class="code" href="#{@class}" onclick="Open('{@class}')"><xsl:apply-templates /></a>
		</xsl:when>
		<xsl:when test="(string(@class)='GLOBAL' or string(@class)='ENUM') and string(@function)!=''">
			<a class="code" href="#{@class}_{@function}" onclick="Open('{@function}')"><xsl:apply-templates /></a>
		</xsl:when>
		<xsl:when test="string(@class)!='' and string(@function)!=''">
			<a class="code" href="#{@class}_{@function}" onclick="OpenAndMove('{@class}','{@function}')"><xsl:apply-templates /></a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates /> <!-- Ignore this Link. -->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="sm:Enums">
	<div>
		<h3 id="Enums">Enums</h3>
		<xsl:apply-templates select="sm:Enum">
			<xsl:sort select="@name" />
		</xsl:apply-templates>
	</div>
</xsl:template>


<xsl:template match="sm:Enum">
	<div id="ENUM_{@name}">
		<a class="trigger" onclick="Toggle('{@name}')">
		<img src="closed.gif" id="img_{@name}" alt="" />
		Enum <span class="descriptionName"><xsl:value-of select="@name" /></span></a>
		<div style="display: none" id="list_{@name}">
		<table>
			<tr>
				<th>Enum</th>
				<th>Value</th>
			</tr>
			<xsl:for-each select="sm:EnumValue">
				<xsl:sort data-type="number" select="@value" />
				<tr class="code">
					<td><xsl:value-of select="@name" /></td>
					<td><xsl:value-of select="@value" /></td>
				</tr>
			</xsl:for-each>
		</table>
		<br />
		</div>
	</div>
</xsl:template>


<xsl:template match="sm:Constants">
	<div>
		<h3 id="Constants">Constants</h3>
		<table>
			<tr>
				<th>Constant</th>
				<th>Value</th>
			</tr>
			<xsl:for-each select="sm:Constant">
				<xsl:sort select="@name" />
				<tr class="code">
					<td><xsl:value-of select="@name" /></td>
					<td><xsl:value-of select="@value" /></td>
				</tr>
			</xsl:for-each>
		</table>
		<br />
	</div>
</xsl:template>

<!-- XXX: This is annoying, how can we tell xsl to just pass the html through? -->
<xsl:template match="sm:code">
	<code><xsl:apply-templates /></code>
</xsl:template>
</xsl:stylesheet>
