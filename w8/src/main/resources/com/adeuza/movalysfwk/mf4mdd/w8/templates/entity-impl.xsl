<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text"/>

	<xsl:include href="commons/file-header.xsl"/>
	<xsl:include href="commons/imports.xsl"/>
	<xsl:include href="commons/constructor.xsl"/>
	<xsl:include href="commons/non-generated.xsl"/>


	<xsl:template match="class">

		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs
			</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="declare-impl-imports"/>

		<xsl:call-template name="model-impl-using"/>

		<xsl:text>&#13;&#13;</xsl:text>

		<xsl:text>namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>&#13;public class </xsl:text><xsl:value-of select="name"/><xsl:text> : </xsl:text>
		<xsl:choose>
			<xsl:when test="embedded = 'true'">
				<xsl:value-of select="embedded-initial-type-short-name"/>
				<xsl:for-each select="./implements/interface">
					<xsl:text>, </xsl:text><xsl:value-of select="@name"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./implements/interface/@name"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text>&#13;</xsl:text>
		<xsl:text>{&#13;</xsl:text>

		<xsl:text>#region Constructors&#13;&#13;</xsl:text>

		<xsl:choose>
			<xsl:when test="embedded = 'true'">
				<!-- Dans le cas d'une classe contenant uniquement des champs en BD, pas de constructeur -->
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="constructor-model-public"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text>&#13;#endregion&#13;</xsl:text>

		<xsl:text>&#13;#region Properties&#13;&#13;</xsl:text><xsl:text></xsl:text>

		<xsl:for-each select="//*[((name() = 'attribute' and not(parent::association)))]">
			<xsl:if test="../embedded = 'true' and @kind = 'basic'">
				<xsl:if test="@enum = 'false'">
					<xsl:text>[Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
				</xsl:if>
				<xsl:if test="@enum = 'true'">
					<xsl:text>[MaxLength(10), Column("</xsl:text><xsl:value-of select="field/@name"/><xsl:text>")]&#13;</xsl:text>
				</xsl:if>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="../embedded = 'true'">
					<xsl:text></xsl:text>
				</xsl:when>
				<xsl:when test="name()= 'association'">
					<xsl:text>private </xsl:text><xsl:value-of select="attribute/@type-short-name"/><xsl:text> _</xsl:text><xsl:value-of
						select="@name"/><xsl:value-of select="attribute/@name-capitalized"/><xsl:text>;&#13;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>private </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text> _</xsl:text><xsl:value-of
						select="@name"/><xsl:text>;&#13;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
			<xsl:text>public </xsl:text>
			<xsl:if test="../embedded = 'true' and @kind = 'basic'">
				<xsl:text>override </xsl:text>
			</xsl:if>
			<xsl:if test="name()= 'association'">
				<xsl:value-of select="attribute/@type-short-name"/><xsl:text> </xsl:text>
				<xsl:value-of select="@name-capitalized"/><xsl:value-of select="attribute/@name-capitalized"/>
				<xsl:text>{</xsl:text>
				<xsl:choose>
					<xsl:when test="../embedded = 'true'">
						<xsl:text>get;</xsl:text>
						<xsl:text>set;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>get { return _</xsl:text><xsl:value-of select="@name"/><xsl:value-of
							select="attribute/@name-capitalized"/><xsl:text>; }</xsl:text>
						<xsl:text>set { _</xsl:text><xsl:value-of select="@name"/><xsl:value-of
							select="attribute/@name-capitalized"/><xsl:text> = value; }</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>}</xsl:text>
				<xsl:text>&#13;&#13;</xsl:text>
			</xsl:if>
			<xsl:if test="name()= 'attribute'">
				<xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text>
				<xsl:value-of select="@name-capitalized"/>
				<xsl:text>{</xsl:text>
				<xsl:choose>
					<xsl:when test="../embedded = 'true'">
						<xsl:text>get;</xsl:text>
						<xsl:text>set;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>get { return _</xsl:text><xsl:value-of select="@name"/><xsl:text>; }</xsl:text>
						<xsl:text>set { _</xsl:text><xsl:value-of select="@name"/><xsl:text> = value; }</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>}</xsl:text>
				<xsl:text>&#13;&#13;</xsl:text>
			</xsl:if>
		</xsl:for-each>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-properties</xsl:with-param>
			<!-- 	<xsl:with-param name="defaultSource"/> -->
		</xsl:call-template>

		<xsl:if test="transient != 'true'">
		</xsl:if>

		<xsl:text>&#13;#endregion&#13;</xsl:text>

		<xsl:text>&#13;#region Associations&#13;&#13;</xsl:text><xsl:text></xsl:text>

		<xsl:for-each select="//*[(name()= 'association') and not(ancestor::association)]">
			<xsl:text>private </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text> _</xsl:text><xsl:value-of
				select="@name"/><xsl:text>;&#13;</xsl:text>
			<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
			<xsl:text>public </xsl:text><xsl:value-of select="@type-short-name"/><xsl:text> </xsl:text><xsl:value-of
				select="@name-capitalized"/><xsl:text></xsl:text>
			<xsl:text>{</xsl:text>
			<xsl:choose>
				<xsl:when test="../embedded = 'true'">
					<xsl:text>get;</xsl:text>
					<xsl:text>set;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>get { return _</xsl:text><xsl:value-of select="@name"/><xsl:text>; }</xsl:text>
					<xsl:text>set { _</xsl:text><xsl:value-of select="@name"/><xsl:text> = value; }</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>}</xsl:text>
			<xsl:text>&#13;&#13;</xsl:text>
		</xsl:for-each>

		<xsl:text>#endregion&#13;</xsl:text>

		<xsl:if test="identifier/attribute">
			<xsl:text>&#13;#region Methods&#13;&#13;</xsl:text><xsl:text></xsl:text>
			<xsl:call-template name="model-method"/>
			<xsl:text>&#13;#endregion&#13;</xsl:text>
		</xsl:if>
		<xsl:text>}</xsl:text>
		<xsl:text>}</xsl:text>

	</xsl:template>


	<xsl:template name="model-method">
		<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
		<xsl:text>public bool IsNewEntity()</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text> return this.</xsl:text><xsl:value-of select="identifier/attribute/@name-capitalized"/><xsl:text> == -1;</xsl:text>
		<xsl:text>}&#13;&#13;</xsl:text>

		<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
		<xsl:text>public string IdToString()</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>return this.</xsl:text><xsl:value-of select="identifier/attribute/@name-capitalized"/><xsl:text>.ToString();</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

</xsl:stylesheet>