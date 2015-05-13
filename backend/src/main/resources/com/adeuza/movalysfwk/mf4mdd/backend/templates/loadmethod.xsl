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

<xsl:output method="text" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="dao">

<xsl:variable name="interface" select="interface"/>
<xsl:variable name="class" select="class"/>

<xsl:text>package </xsl:text><xsl:value-of select="$interface/package"/>;

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.Public ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethodHelper;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethodIdHelper;
<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable']) > 0">
<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MCodableEntity']) > 0">
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethodCodeHelper;
</xsl:if>
<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableBOEntity']) > 0 and count($class/implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']) > 0">
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethodReferenceHelper;
</xsl:if>
</xsl:if>

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>


/**
 * Enumération décrivant les différentes méthodes de chargement des entités de classe <xsl:value-of select="$interface/name"/>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@Public	 
public enum LoadMethod<xsl:value-of select="$interface/name"/> implements LoadMethod&lt;<xsl:value-of select="$interface/name"/>&gt; {
	
	/**
	 * Méthode par défaut utilisant la clé primaire et l'identifiant de <xsl:value-of select="$interface/name"/> 
	 */
	BY_ID(true,new LoadMethodIdHelper())
	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'MCodableEntity']) > 0">
	<xsl:text>,</xsl:text>
	/**
	 * Méthode utilisant le code de <xsl:value-of select="$interface/name"/>
	 */
	BY_CODE(false,new LoadMethodCodeHelper())
	</xsl:if>
	<xsl:if test="count($class/implements/interface/linked-interfaces/linked-interface[name = 'IdentifiableBOEntity']) > 0 and count($class/implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']) > 0">
	<xsl:text>,
	/**
	 * Méthode utilisant les références de </xsl:text><xsl:value-of select="$interface/name"/><xsl:text>
	 */
	BY_REFERENCE(false,new LoadMethodReferenceHelper())</xsl:text>
	</xsl:if>
		
//@non-generated-start[loadable-method]
<xsl:value-of select="non-generated/bloc[@id='loadable-method']"/>
<xsl:text>//@non-generated-end</xsl:text>
	;

	/**
	 * Est ce la méthode par défaut utilisant l'ID de l'objet
	 */
	private boolean bIsDefault = true;

	/**
	 * Helper pour le loadMethod
	 */
	private LoadMethodHelper loadMethodHelper = null;
		
	/**
	 * Constructeur minimum
	 *
	 * @param p_bIsdefault boolean indiquant si la méthode est la méthode par défaut utilisant l'ID de l'objet
	 * @param p_oHelper helper pour le loadMethod
	 */
	private LoadMethod<xsl:value-of select="$interface/name"/>(boolean p_bIsdefault, LoadMethodHelper p_oHelper) {
		this.bIsDefault = p_bIsdefault;
		this.loadMethodHelper = p_oHelper;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod#isDefault()
	 */
	@Override
	public boolean isDefault() {
		return this.bIsDefault;
	}

	/**
	 * {@inheritDoc}
	 *
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod#getHelper()
	 */
	@Override
	public LoadMethodHelper getHelper() {
		return this.loadMethodHelper;
	}
}
</xsl:template>

</xsl:stylesheet>