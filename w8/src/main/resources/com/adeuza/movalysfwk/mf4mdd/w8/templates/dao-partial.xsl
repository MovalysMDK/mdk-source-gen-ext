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
<xsl:include href="dao/dao-create.xsl"/>
<xsl:include href="dao/dao-select.xsl"/>
<xsl:include href="dao/dao-insert-update.xsl"/>
<xsl:include href="dao/dao-delete.xsl"/>
<xsl:include href="dao/dao-associations.xsl"/>
<xsl:include href="dao/method-signature/dao-deleteby.xsl"/>
<xsl:include href="dao/method-signature/dao-getby.xsl"/>
<xsl:include href="dao/method-signature/dao-getlistby.xsl"/>
<xsl:include href="dao/method-signature/dao-getnbby.xsl"/>


<xsl:template match="dao">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-impl-imports" />
	<xsl:call-template name="dao-imports"/>
	
	<xsl:text>&#13;&#13;</xsl:text>
	<xsl:text>namespace </xsl:text><xsl:value-of select="package"/><xsl:text>{&#13;</xsl:text>
	<xsl:text>public partial class </xsl:text><xsl:value-of select="name"/>
	<xsl:text> : </xsl:text>
	<xsl:choose>
		<xsl:when test="./class/@join-class='true'">AbstractEntityDao</xsl:when>
		<xsl:otherwise>AbstractIdentifiableDao</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&lt;</xsl:text><xsl:value-of select="./class/implements/interface/@name"/><xsl:text>&gt;, </xsl:text><xsl:value-of select="./implements/interface/@name"/>
	<xsl:text>{&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;</xsl:text>

	<xsl:apply-templates select="class" mode="dao-methode-region"/>
	<xsl:apply-templates select="." mode="dao-create-region"/>
	<xsl:apply-templates select="." mode="dao-select-region"/>
	<xsl:apply-templates select="." mode="dao-insert-update"/>
	<xsl:apply-templates select="." mode="dao-delete"/>
	<xsl:apply-templates select="./class/association[@type='many-to-many' and join-table]" mode="implementation"/>
	
	<xsl:text>#region METHOD-SIGNATURE&#13;&#13;</xsl:text>
	
	<xsl:apply-templates select="method-signature" mode="implementation"/>
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template>

	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<xsl:template match="class" mode="dao-methode-region" >
	<xsl:text>#region Methods&#13;&#13;</xsl:text>
	
		<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	    protected override Func&lt;<xsl:value-of select="implements/interface/@name"/><xsl:text>, Expression&lt;Func&lt;</xsl:text><xsl:value-of select="implements/interface/@name"/>, bool&gt;&gt;&gt; GetLambdaPrimaryKey()
	    {
	    	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">GetLambdaPrimaryKey</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>return pk => c => </xsl:text><xsl:apply-templates select="identifier/attribute" mode="identifier-name" /><xsl:text>;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
	    }
		
		<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	    protected override void SetNewEntityId(<xsl:value-of select="implements/interface/@name"/><xsl:text> </xsl:text>Entity, IMFContext context)
	    {
	    	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">SetNewEntityId</xsl:with-param>
				<xsl:with-param name="defaultSource">
	        		<xsl:apply-templates select="identifier/attribute" mode="identifier-set" />
	        	</xsl:with-param>
	        </xsl:call-template>
	    }
	    
	    <xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	    protected override async Task SetNewEntityIdAsync(<xsl:value-of select="implements/interface/@name"/><xsl:text> </xsl:text>Entity, IMFContext context)
	    {
	    	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">SetNewEntityIdAsync</xsl:with-param>
				<xsl:with-param name="defaultSource">
			        <xsl:apply-templates select="identifier/attribute" mode="identifier-set" >
			        	<xsl:with-param name="async" select="'true'"/>
			        </xsl:apply-templates>
			    </xsl:with-param>
			</xsl:call-template>
	    }
	    
	<xsl:text>#endregion&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="identifier-name">
	<xsl:if test="position() > 1">
		<xsl:text> &#38;&#38; </xsl:text>
	</xsl:if>
	<xsl:text>c.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> == pk.</xsl:text><xsl:value-of select="@name-capitalized"/>
</xsl:template>

<xsl:template match="attribute" mode="identifier-set">
	<xsl:param name="async" />
	
	<xsl:choose>
		<xsl:when test="../../@join-class='true'">
			<xsl:text>Entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> = -1;&#13;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> = </xsl:text><xsl:if test="$async='true'">await </xsl:if><xsl:text>this.GetNewEntityId</xsl:text><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(context);&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
