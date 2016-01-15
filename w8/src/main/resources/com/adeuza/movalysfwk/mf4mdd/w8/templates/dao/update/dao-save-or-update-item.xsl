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

<xsl:template match="dao" mode="save-or-update-item">
	<xsl:param name="async" />
	<xsl:param name="in-list" />
	
    <xsl:apply-templates select="./class/descendant::association[not(@transient='true') and (@type='one-to-one' or @type='many-to-one')]" mode="save-association" >
    	<xsl:with-param name="async"><xsl:value-of select="$async" /></xsl:with-param>
    </xsl:apply-templates>
    <xsl:if test="$async='true'">await </xsl:if>this.SaveEntity<xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./class/name-uncapitalized"/>, typeof(<xsl:value-of select="./interface/name"/>), p_oContext);
    p_oEntitySession.MarkAsSaved(typeof(<xsl:value-of select="./interface/name"/>), <xsl:value-of select="./class/name-uncapitalized"/>
    <xsl:text>);</xsl:text>
    
    <xsl:if test="./class/parameters/parameter[@name='oldidholder'] = 'true'">
		<xsl:value-of select="./class/name-uncapitalized"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="class/attribute[parameters/parameter[@name='oldidholder'] = 'true']/set-accessor"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="./class/name-uncapitalized"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="class/identifier/descendant::attribute[1]/@name-capitalized"/>
		<xsl:text>;&#13;</xsl:text>
	</xsl:if>
	
	<xsl:apply-templates select="./class/descendant::association[not(@transient='true') and (@type='one-to-many' or @type='many-to-many')]" mode="save-association">
		<xsl:with-param name="async"><xsl:value-of select="$async" /></xsl:with-param>
    </xsl:apply-templates>
          
</xsl:template>


<xsl:template match="*" mode="save-or-update-item" priority="-900">
	<xsl:comment> [dao-save-or-update-item.xsl] <xsl:value-of select="."/> mode='save-or-update-item'</xsl:comment>
</xsl:template>


<xsl:template match="association" mode="save-association">
	<xsl:param name="async" />

	<xsl:choose> 
		<xsl:when test="not(/dao/class/stereotypes/stereotype[@name='adjava_classFromExpandableAttributeStereotype'])">
			if (p_oCascadeSet.Contains(<xsl:value-of select="../../class/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>if(</xsl:text>
			<xsl:choose>
			   	<xsl:when test="@type='many-to-many' or @type='one-to-many'">
			   		<xsl:value-of select="./variable-name"/>
			   	</xsl:when>
			   	<xsl:otherwise>
			   		<xsl:value-of select="../../class/name-uncapitalized"/>.<xsl:value-of select="./@name-capitalized"/>
			   	</xsl:otherwise>
		   	</xsl:choose>
		   	<xsl:text>!=null) {&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	
    <xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/><xsl:text> = (</xsl:text>
    <xsl:value-of select="./dao/name"/><xsl:text>)ClassLoader.GetInstance().GetBean&lt;</xsl:text>
    <xsl:value-of select="./dao-interface/name"/><xsl:text>&gt;();</xsl:text>
    
    <xsl:if test="@type='many-to-many' or @type='one-to-many'">
    	<xsl:text>foreach (</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> </xsl:text>
    	<xsl:value-of select="./variable-name"/> in <xsl:value-of select="../../class/name-uncapitalized"/><xsl:text>.</xsl:text>
    	<xsl:value-of select="./@name-capitalized"/><xsl:text>) {</xsl:text>
    </xsl:if>
	<xsl:if test="./@opposite-capitalized-name != ''">                        
	    <xsl:choose>
			<!-- For many-to-many and many-to-one cases, we check that the opposite navigation is possible in order to access to the cascaded data-->
			<xsl:when test="@type='many-to-one' and @opposite-navigable='true'">
				if (<xsl:value-of select="../../class/name-uncapitalized"/>.<xsl:value-of select="./@name-capitalized"/>.<xsl:value-of select="./@opposite-capitalized-name"/>.IndexOf(<xsl:value-of select="../../class/name-uncapitalized"/>) == -1) {
		    		<xsl:value-of select="../../class/name-uncapitalized"/>.<xsl:value-of select="./@name-capitalized"/>.<xsl:value-of select="./@opposite-capitalized-name"/>.Add(<xsl:value-of select="../../class/name-uncapitalized"/>);
		    	}
	        </xsl:when>
	        <xsl:when test="@type='many-to-many' and @opposite-navigable='true'">
				if (<xsl:value-of select="./variable-name"/>.<xsl:value-of select="./@opposite-capitalized-name"/>.IndexOf(<xsl:value-of select="../../class/name-uncapitalized"/>) == -1) {
		    		<xsl:value-of select="./variable-name"/>.<xsl:value-of select="./@opposite-capitalized-name"/>.Add(<xsl:value-of select="../../class/name-uncapitalized"/>);
		    	}
	        </xsl:when>
	        <xsl:when test="@type='one-to-many'">
		    	<xsl:value-of select="./variable-name"/>.<xsl:value-of select="./@opposite-capitalized-name"/> = <xsl:value-of select="../../class/name-uncapitalized"/>;
	        </xsl:when>
		</xsl:choose>
	</xsl:if>
   	<xsl:if test="$async='true'">await </xsl:if><xsl:value-of select="./dao/bean-ref"/>.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
   	<xsl:choose>
	   	<xsl:when test="@type='many-to-many' or @type='one-to-many'">
	   		<xsl:value-of select="./variable-name"/>
	   	</xsl:when>
	   	<xsl:otherwise>
	   		<xsl:value-of select="../../class/name-uncapitalized"/>.<xsl:value-of select="./@name-capitalized"/>
	   	</xsl:otherwise>
   	</xsl:choose>
   	<xsl:text>, </xsl:text>
   	<xsl:choose>
	   	<xsl:when test="not(/dao/class/stereotypes/stereotype[@name='adjava_classFromExpandableAttributeStereotype'])">
	   		<xsl:text>p_oCascadeSet</xsl:text>
	   	</xsl:when>
	   	<xsl:otherwise>
	   		<xsl:text>CascadeSet.NONE</xsl:text>
	   	</xsl:otherwise>
   	</xsl:choose>
   	<xsl:text>, p_oEntitySession, p_oContext);&#13;</xsl:text>
   	<xsl:if test="@type='many-to-many' or @type='one-to-many'">
   		<xsl:variable name="object-name"><xsl:value-of select="./variable-name"/></xsl:variable>
   		<xsl:text>}</xsl:text>
   		<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text>
   		<xsl:value-of select="$object-name"/><xsl:text>s</xsl:text><xsl:text> = </xsl:text>
   		<xsl:value-of select="./dao/bean-ref"/><xsl:text>.Get</xsl:text>
   		<xsl:value-of select="./class/name"/><xsl:text>s</xsl:text>
   		<xsl:text>(p_oContext);</xsl:text>
		<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text>
		<xsl:value-of select="$object-name"/><xsl:text>s</xsl:text><xsl:text>ToDelete = new List&lt;</xsl:text>
		<xsl:value-of select="./interface/name"/><xsl:text>&gt;();</xsl:text>
		<xsl:text>foreach (</xsl:text>
		<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text>
		<xsl:value-of select="$object-name"/><xsl:text>Item in </xsl:text>
		<xsl:value-of select="$object-name"/><xsl:text>s</xsl:text>
		<xsl:text>)&#13;{&#13;bool found = false;&#13;</xsl:text>
		<xsl:text>foreach (</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> </xsl:text>
		<xsl:value-of select="$object-name"/><xsl:text> in </xsl:text>
		<xsl:value-of select="../../class/name-uncapitalized"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="./@name-capitalized"/>
		<xsl:text>)&#13;{&#13;if (</xsl:text>
		<xsl:for-each select="./attribute">
			<xsl:value-of select="$object-name"/><xsl:text>.</xsl:text><xsl:value-of select="./@name-capitalized"/>
			<xsl:text> == </xsl:text>
			<xsl:value-of select="$object-name"/><xsl:text>Item.</xsl:text><xsl:value-of select="./@name-capitalized"/>
			<xsl:text> <![CDATA[&&]]>&#13;</xsl:text>
		</xsl:for-each>
		<xsl:variable name="association-name"><xsl:value-of select="./@opposite-capitalized-name"/></xsl:variable>
		<xsl:for-each select="../identifier">
			<xsl:value-of select="$object-name"/><xsl:text>.</xsl:text>
			<xsl:if test="../@type='one-to-many'">
				<xsl:value-of select="$association-name"/><xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:value-of select="./attribute/@name-capitalized"/>
			<xsl:text> == </xsl:text>
			<xsl:value-of select="$object-name"/><xsl:text>Item.</xsl:text>
			<xsl:if test="../@type='one-to-many'">
				<xsl:value-of select="$association-name"/><xsl:text>.</xsl:text>
			</xsl:if>
			<xsl:value-of select="./attribute/@name-capitalized"/>
		</xsl:for-each>
		<xsl:text>)&#13;{&#13;found = true;&#13;}&#13;}&#13;if (!found)&#13;{&#13;</xsl:text>
		<xsl:value-of select="./variable-name"/><xsl:text>s</xsl:text><xsl:text>ToDelete.Add(</xsl:text>
		<xsl:value-of select="./variable-name"/><xsl:text>Item);&#13;}&#13;}&#13;foreach (</xsl:text>
		<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./variable-name"/>
		<xsl:text> in </xsl:text><xsl:value-of select="./variable-name"/><xsl:text>s</xsl:text>
		<xsl:text>ToDelete)&#13;{&#13;</xsl:text>
		<xsl:value-of select="./dao/bean-ref"/><xsl:text>.Delete</xsl:text>
		<xsl:value-of select="./class/name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="./variable-name"/><xsl:text>.</xsl:text>
		<xsl:value-of select="../descendant::attribute[1]/@name-capitalized"/>
		<xsl:text>, p_oContext);&#13;}&#13;</xsl:text>
   	</xsl:if>
   	<xsl:text>}&#13;</xsl:text>
</xsl:template>

</xsl:stylesheet>
