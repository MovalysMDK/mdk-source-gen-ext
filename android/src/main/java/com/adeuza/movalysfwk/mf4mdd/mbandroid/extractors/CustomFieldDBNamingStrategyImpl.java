/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

import java.util.Map;

import com.a2a.adjava.schema.Field;
import com.a2a.adjava.schema.naming.DbNamingStrategyImpl;

/**
 * <p>TODO Décrire la classe CustomFieldDBNamingStrategyImpl</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class CustomFieldDBNamingStrategyImpl extends DbNamingStrategyImpl {

	private static final String PK_PREFIX_OPTION = "pkPrefix";
	
	private static final String TABLE_PREFIX_OPTION = "tablePrefix";

	/**
	 * Options
	 */
	private Map<String, String> options;

	/**
	 * Préfixe de la table stockant la déclaration des champs personnalisés. 
	 */
	private String fieldTablePrefix;

	/**
	 * Préfixe de la clé primaire des tables de déclaration des champs personnalisés
	 */
	private String fieldPKPrefix;
	
	/**
	 * Préfixe de la table stockant les valeurs des champs personnalisés. 
	 */
	private String valueTablePrefix;

	/**
	 * Préfixe de la clé primaire des tables de stockage des valeurs des champs personnalisés
	 */

	private String valuePKPrefix;

	/**
	 * {@inheritDoc}
	 */
	public void setOptions( Map<String,String> p_oOptions ) {
		this.options = p_oOptions;
		this.fieldTablePrefix	= p_oOptions.get("fieldTablePrefix");
		this.fieldPKPrefix		= p_oOptions.get("fieldPkPrefix");

		this.valueTablePrefix	= p_oOptions.get("valueTablePrefix");
		this.valuePKPrefix		= p_oOptions.get("valuePkPrefix");
	}

	public void setFieldOptions() {
		this.options.put(TABLE_PREFIX_OPTION, this.fieldTablePrefix);
		this.options.put(PK_PREFIX_OPTION, this.fieldPKPrefix);
		super.setOptions(this.options);
	}
	
	public void setValueOptions() {
		this.options.put(TABLE_PREFIX_OPTION, this.valueTablePrefix);
		this.options.put(PK_PREFIX_OPTION, this.valuePKPrefix);
		super.setOptions(this.options);
	}

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.schema.naming.DbNamingStrategyImpl#getFKColumnName(java.lang.String, com.a2a.adjava.schema.Field)
	 */
	public String getFKColumnName( String p_sAssociationEndName, Field p_oField ) {
		return this.getName(p_sAssociationEndName.toUpperCase(), p_oField.getName(), this.getIdentifierMaxLength(), "");
	}
}
