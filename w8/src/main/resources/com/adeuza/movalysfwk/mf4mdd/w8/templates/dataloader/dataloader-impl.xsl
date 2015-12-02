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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

<xsl:output method="text"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl" />
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>

	<xsl:template match="dataloader-impl">
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="data-loader-imports"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-impl-imports"/>		
		
		<xsl:text>&#13;namespace </xsl:text><xsl:value-of select="package"/>
		<xsl:text>{</xsl:text>
		<xsl:call-template name="start-class" />
		<xsl:text>private static readonly CascadeSet LOAD_CASCADE = CascadeSet.Of(</xsl:text>
		<xsl:apply-templates select="cascades/cascade" mode="cascade-set" />
		<xsl:text>);</xsl:text>
		
		<xsl:apply-templates select="dataloader-interface/combos/combo" mode="combo-init" />
		
		<!-- custom attributes -->
		<xsl:text>&#13;</xsl:text>
	    <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">attributes</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		
		<xsl:if test="dao-interface/dao">		
		
			<xsl:text>private </xsl:text>
			<xsl:value-of select="dao-interface/name" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="dao-interface/bean-name" />
			<xsl:text> = null;</xsl:text>
		
		</xsl:if>
		
		<xsl:if test="dataloader-interface/type = 'LIST'">
		<xsl:text>private </xsl:text>
		<xsl:text>List</xsl:text><![CDATA[<]]><xsl:value-of select="observed-entities/entity/name"/><![CDATA[>]]><xsl:text> fullList;</xsl:text>
		</xsl:if>
		
		<xsl:text>&#13;#region constructeur&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text>()</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:if test="dao-interface">	
	            <xsl:value-of select="dao-interface/bean-name" /><xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="dao-interface/name"/><xsl:text>&gt;();</xsl:text>
				<xsl:text>&#13;</xsl:text>
	         	<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">Constructor</xsl:with-param>
					<xsl:with-param name="defaultSource"/>
				</xsl:call-template>
			</xsl:if>
        <xsl:text>}</xsl:text>
		<xsl:text>&#13;#endregion&#13;</xsl:text>
		
		
		<!-- load method -->
		<xsl:apply-templates select="." mode="loadMethod"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="." mode="loadMethodAsync"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:if test="dataloader-interface/type = 'LIST'">
			<xsl:apply-templates select="." mode="filterMethod"/>
			<xsl:text>&#13;</xsl:text>
			<xsl:apply-templates select="." mode="getDataMethod"/>
			<xsl:text>&#13;</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="dataloader-interface/combos/combo" mode="combo-getter" />
        
       	<!-- custom methods -->
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
		</xsl:call-template>
		
		<xsl:text>}}</xsl:text>
	</xsl:template>
	
	<!--  COMBO -->
	<xsl:template match="combo" mode="combo-init">
		<xsl:text>private List&lt;</xsl:text><xsl:value-of select="entity"/><xsl:text>&gt; </xsl:text><xsl:value-of select="entity-attribute-name"/><xsl:text>Lst;</xsl:text>
	</xsl:template>
	<xsl:template match="combo" mode="combo-getter">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected void GetList</xsl:text><xsl:value-of select="entity-getter-name"/><xsl:text>(IMFContext context) {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">getList</xsl:with-param>
			<xsl:with-param name="defaultSource">		
			<xsl:value-of select="dao-name"/><xsl:text> </xsl:text><xsl:value-of select="dao-attribute-name"/><xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="dao-name"/><xsl:text>&gt;();</xsl:text>
		    <xsl:text>this.</xsl:text><xsl:value-of select="entity-attribute-name"/><xsl:text>Lst = </xsl:text><xsl:value-of select="dao-attribute-name"/><xsl:text>.Get</xsl:text><xsl:value-of select="dao-impl-name" /><xsl:text>s(context);&#13;</xsl:text>		
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
		
		
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>public List&lt;</xsl:text><xsl:value-of select="entity"/><xsl:text>&gt; GetList</xsl:text><xsl:value-of select="entity-getter-name"/><xsl:text>() {&#13;</xsl:text>
				<xsl:text>return this.</xsl:text><xsl:value-of select="entity-attribute-name"/><xsl:text>Lst;&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	<xsl:template match="combo" mode="call-combo">
        	<xsl:text>this.GetList</xsl:text><xsl:value-of select="entity-getter-name"/><xsl:text>(context);</xsl:text>
	</xsl:template>
	<!-- END COMBO -->
	
	<xsl:template match="dataloader-impl[not(dataloader-interface/type='LIST') and not(dataloader-interface/entity-type/transient = 'true')]" mode="loadMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override </xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text> Load(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
	        <xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">				
		        	<xsl:if test="dao-interface">
			            <xsl:value-of select="observed-entities/entity/name"/><xsl:text> </xsl:text>
			            <xsl:value-of select="dao-interface/dao/class/name-uncapitalized" />
			        	<xsl:text> = </xsl:text><xsl:value-of select="dao-interface/bean-name" /><xsl:text>.Get</xsl:text>
			            <xsl:value-of select="dao-interface/dao/class/name" />
			        	<xsl:text>(this.GetItemId(), LOAD_CASCADE, context);</xsl:text>
						<xsl:apply-templates select="dataloader-interface/combos/combo" mode="call-combo" />
			            <xsl:text>return </xsl:text><xsl:value-of select="dao-interface/dao/class/name-uncapitalized" /><xsl:text>;</xsl:text>
			        </xsl:if>
		            <xsl:if test="not(dao-interface)">
		        		<xsl:text>&#13;if (this.GetData() != null)</xsl:text>
		        		<xsl:text>&#13;{</xsl:text>
		        		<xsl:text>&#13;return this.GetData();</xsl:text>
		        		<xsl:text>&#13;}</xsl:text>
		        		<xsl:text>&#13;else</xsl:text>
		        		<xsl:text>&#13;{</xsl:text>
		        		<xsl:text>&#13;return ClassLoader.GetInstance().GetBean</xsl:text><![CDATA[<]]><xsl:value-of select="observed-entities/entity/name" /><![CDATA[>]]><xsl:text>();</xsl:text>
		        		<xsl:text>&#13;}</xsl:text>
		        	</xsl:if>
		        	<xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[not(dataloader-interface/type='LIST') and dataloader-interface/entity-type/transient = 'true']" mode="loadMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override </xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text> Load(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
	        <xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">		        	
	        		<xsl:text>return this.GetData();&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST' and not(dataloader-interface/entity-type/transient = 'true')]" mode="loadMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; Load(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">
		            <xsl:text>List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; </xsl:text>
		            <xsl:value-of select="dao-interface/dao/class/name-uncapitalized" />
		        	<xsl:text> = </xsl:text><xsl:value-of select="dao-interface/bean-name" /><xsl:text>.Get</xsl:text>
		            <xsl:value-of select="dao-interface/dao/class/name" />
		        	<xsl:text>s(LOAD_CASCADE, context);</xsl:text>
					<xsl:apply-templates select="dataloader-interface/combos/combo" mode="call-combo" />
					<xsl:text>fullList = </xsl:text><xsl:value-of select="dao-interface/dao/class/name-uncapitalized" /><xsl:text>;</xsl:text>
		            <xsl:text>return </xsl:text><xsl:value-of select="dao-interface/dao/class/name-uncapitalized" /><xsl:text>;</xsl:text>
		            <xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST' and dataloader-interface/entity-type/transient = 'true']" mode="loadMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; Load(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">
		            <xsl:text>return this.GetData();&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<!-- LOADMETHOD (default) -->
	<xsl:template match="dataloader-impl" mode="loadMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override </xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text> Load(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
		    <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>return null;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='SINGLE' and not(dataloader-interface/entity-type/transient = 'true')]" mode="loadMethodAsync">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override async Task&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; LoadAsync(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">loadAsync</xsl:with-param>
				<xsl:with-param name="defaultSource">
		        	<xsl:if test="dao-interface">
						<xsl:apply-templates select="dataloader-interface/combos/combo" mode="call-combo" />
			            <xsl:text>return await </xsl:text>
			            <xsl:value-of select="dao-interface/bean-name" /><xsl:text>.Get</xsl:text>
			            <xsl:value-of select="dao-interface/dao/class/name" />
			        	<xsl:text>Async(this.GetItemId(), LOAD_CASCADE, context);</xsl:text>
		        	</xsl:if>
		        	<xsl:if test="not(dao-interface)">
		        	<xsl:text>return null;</xsl:text>
		        	</xsl:if>
		        	<xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='SINGLE' and dataloader-interface/entity-type/transient = 'true']" mode="loadMethodAsync">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override async Task&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; LoadAsync(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">loadAsync</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>&#13;</xsl:text>
		        	<xsl:text>return this.GetData();</xsl:text>
		        	<xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST' and not(dataloader-interface/entity-type/transient = 'true')]" mode="loadMethodAsync">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override async Task&lt;List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt;&gt; LoadAsync(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
			<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">loadAsync</xsl:with-param>
				<xsl:with-param name="defaultSource">
		        	<xsl:if test="dao-interface">
						<xsl:apply-templates select="dataloader-interface/combos/combo" mode="call-combo" />
			            <xsl:text>return await </xsl:text>
			            <xsl:value-of select="dao-interface/bean-name" /><xsl:text>.Get</xsl:text>
			            <xsl:value-of select="dao-interface/dao/class/name" />
			        	<xsl:text>sAsync(LOAD_CASCADE, context);</xsl:text>
		        	</xsl:if>
		        	<xsl:if test="not(dao-interface)">
		        		<xsl:text>&#13;if (this.GetData() != null)</xsl:text>
		        		<xsl:text>&#13;{</xsl:text>
		        		<xsl:text>&#13;return this.GetData();</xsl:text>
		        		<xsl:text>&#13;}</xsl:text>
		        		<xsl:text>&#13;else</xsl:text>
		        		<xsl:text>&#13;{</xsl:text>
		        		<xsl:text>&#13;return ClassLoader.GetInstance().GetBean</xsl:text><![CDATA[<]]><xsl:value-of select="observed-entities/entity/name" /><![CDATA[>]]><xsl:text>();</xsl:text>
		        		<xsl:text>&#13;}</xsl:text>
		        	</xsl:if>
		        	<xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>&#13;}</xsl:text>
	</xsl:template>
	
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST' and dataloader-interface/entity-type/transient = 'true']" mode="loadMethodAsync">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override async Task&lt;List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt;&gt; LoadAsync(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
			<xsl:text>&#13;</xsl:text>
        	<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">loadAsync</xsl:with-param>
				<xsl:with-param name="defaultSource">
		        	<xsl:text>&#13;</xsl:text>
		        	<xsl:text>return this.GetData();</xsl:text>
		        	<xsl:text>&#13;</xsl:text>
		        </xsl:with-param>
		    </xsl:call-template>
        <xsl:text>&#13;}</xsl:text>
	</xsl:template>
	
	<!-- LOADMETHODASYNC (default) -->
	<xsl:template match="dataloader-impl" mode="loadMethodAsync">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>protected override async Task&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; LoadAsync(IMFContext context)</xsl:text>
        <xsl:text>{</xsl:text>
        	<xsl:text>&#13;</xsl:text>
		    <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">load</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>return null;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<!-- FILTERMETHOD (default) -->
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST']" mode="filterMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>public override void FilterList(IMEntity entitySearch, IMFContext context)</xsl:text>
        <xsl:text>{&#13;</xsl:text>
		    <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">FilterMethod</xsl:with-param>
			</xsl:call-template>
			<!-- <xsl:value-of select="observed-entities/entity/name"/><xsl:text> </xsl:text>
			<xsl:value-of select="dao-interface/dao/class/name-uncapitalized"/><xsl:text>Search = null;</xsl:text> -->
			<xsl:text>// reload the dataloader&#13;</xsl:text>
			<xsl:text>base.FilterList(entitySearch, context);&#13;</xsl:text>
        <xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<!-- FILTERMETHOD (default) -->
	<xsl:template match="dataloader-impl[dataloader-interface/type='LIST']" mode="getDataMethod">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>public override List&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt; GetData()</xsl:text>
        <xsl:text>{&#13;</xsl:text>
        
		    <xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">getData</xsl:with-param>
			</xsl:call-template>
			<xsl:text>return fullList;</xsl:text>
        <xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template name="start-class">
		<xsl:text>&#13;</xsl:text>
		<xsl:text>///&lt;inheritDoc&#47;&gt;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>public class </xsl:text><xsl:value-of select="name"/><xsl:text> : </xsl:text>
		<xsl:choose>
			<xsl:when test="dataloader-interface/type = 'LIST'">
				<xsl:text>AbstractListDataLoader</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>AbstractDataLoader</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&lt;</xsl:text><xsl:value-of select="observed-entities/entity/name"/><xsl:text>&gt;, </xsl:text>

		<xsl:apply-templates select="implements/interface" mode="add-interface" />		
		<xsl:text>{</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="interface" mode="add-interface">
			<xsl:value-of select="@name"/>
			<xsl:if test="position() != count(../interface)">
				<xsl:text>, </xsl:text>
			</xsl:if>
	</xsl:template>
	
	<xsl:template match="cascade" mode="cascade-set">
		<xsl:value-of select="name"/>
		<xsl:if test="position() != count(../cascade)">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>